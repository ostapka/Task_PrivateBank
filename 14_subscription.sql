CREATE SUBSCRIPTION my_op_sub 
CONNECTION 'host=172.22.0.2 port=5432 user=postgres password=postgres dbname=mydb' 
PUBLICATION my_op_pub;