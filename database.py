import psycopg2

class Database:
    def __init__(self, name):
        self._conn = psycopg2.connect(database=name,
                                user='postgres',
                                password='newlf2080',
                                host='localhost',
                                port='5432')
        self._cursor = self._conn.cursor()

    def __enter__(self):        # overriding to make the class autoclausable
        return self

    def __exit__(self, exc_type, exc_val, exc_tb): # overriding to make the class autoclosable
        self.close()

    @property           # getter of connection object
    def connection(self):
        return self._conn

    @property
    def cursor(self):   # getter of cursor object
        return self._cursor

    def commit(self):
        self.connection.commit()

    def close(self,commit=False):
        if not commit:
            self.commit()
        self.connection.close()
        
    def execute(self,sql,params=None):
        self.cursor.execute(sql, params or ())
    
    def executemany(self,sql, params=None):
    	self.cursor.executemany(sql, params or ())
        
    def fetchall(self):
        return self.cursor.fetchall()
    
    def fetchone(self):
        return self.cursor.fetchone()
    
    def query(self, sql, params=None):
        self.cursor.execure(sql, params or ())
    def mogrify(self,sql,params=None):
        self.cursor.mogrify(sql, params or ())

''' credits to carusot42's answer in this post:
https://stackoverflow.com/questions/38076220/python-mysqldb-connection-in-a-class/38078544
for helping with a way to make an autoclosable class for a database connection.
'''
