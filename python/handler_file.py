import boto3
from pyspark.sql import SparkSession
import os
import datetime
from datetime import date

# Inicie uma sessão Spark
spark = SparkSession.builder.appName("AWS Glue View to S3 and SNS").getOrCreate()

# Carregue a tabela existente como um DataFrame
df = spark.read \
    .format("awsglue") \
    .option("database", "database_name") \
    .option("tableName", "table_name") \
    .load()

# Crie a view a partir do DataFrame
df.createOrReplaceTempView("accounts")

# Faça uma consulta na view criada
result = spark.sql("SELECT * FROM accounts")

bucket_name = os.environ['bucket_name']
key = "result-report-glue"
datetime_now = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
filename = "extract-report-from-glue-{}.csv".format()
anomesdia = date.today()
# Salve o resultado como um arquivo CSV no S3
result.write \
    .format("csv") \
    .option("header", "true") \
    .mode("overwrite") \
    .save("{}-{}/{}/{}".format(bucket_name, key, anomesdia, filename))

# Inicialize o SNS client
sns = boto3.client("sns")

account_id = os.environ['ACCOUNT_ID']
region = os.environ['REGION']
topic_name = os.enrion['TOPIC_NAME']
# Publique uma mensagem no tópico SNS
sns.publish(
    TopicArn="arn:aws:sns:{}:{}:{}".format(account_id, region, topic_name),
    Message="Arquivo CSV gerado com sucesso!",
)

# Encerre a sessão Spark
spark.stop()