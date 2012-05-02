
node[:sphinx][:db][:host] = 'localhost'
node[:sphinx][:db][:user] = 'root'
node[:sphinx][:db][:password] = ''
node[:sphinx][:db][:schema] = 'mysql'
node[:sphinx][:db][:sql_query] = 'SELECT id, group_id, UNIX_TIMESTAMP(date_added) AS date_added, title, content FROM documents'
node[:sphinx][:db][:sql_attr_uint] = 'group_id'
node[:sphinx][:db][:sql_attr_timestamp] = 'date_added'
node[:sphinx][:db][:sql_query_info] = 'SELECT * FROM documents WHERE id=$id'
node[:sphinx][:mem_limit] = '256M'