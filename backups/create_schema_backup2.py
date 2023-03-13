import psycopg2
import sys
import subprocess
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

        
# login as default user and create the database for the api

conn = psycopg2.connect(user="postgres", 	
                            password="newlf2080",
                            host="127.0.0.1",
                            port="5432")

conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
c = conn.cursor()
c.execute('''create database msds;''')
c.close()
conn.close()

# run all the create table statements
if __name__ == '__main__':
    config = {'database': 'msds', 'user':'postgres', 'password':'newlf2080',
              'host':'127.0.0.1', 'port':'5432'}
    try:
        conn = psycopg2.connect(**config)
        c = conn.cursor()
        with open('resources/create_queries','r') as q:
            for line in q.readlines():
                c.execute(line.strip())
                conn.commit()
        c.execute('ALTER SEQUENCE additive_id_seq RESTART WITH 1')     
        c.execute('ALTER SEQUENCE base_id_seq RESTART WITH 1')
        c.execute('ALTER SEQUENCE company_id_seq RESTART WITH 1')
        c.execute('ALTER SEQUENCE ghs_id_seq RESTART WITH 1') 
        c.execute('ALTER SEQUENCE msds_msds_no_seq RESTART WITH 1') 
        c.execute('ALTER SEQUENCE product_id_seq RESTART WITH 1') 
        c.execute('ALTER SEQUENCE product_id_seq RESTART WITH 1')
        c.execute('CREATE EXTENSION plpython3u') # remember to add in dockerfile run: sudo apt install postgresql-plpython3-12
        c.execute('''CREATE FUNCTION calculate_concentration(additive_quantity float8,substance_quantity float8)
                    RETURNS float8 LANGUAGE plpython3u immutable leakproof strict
                    AS $$ return (additive_quantity*substance_quantity)/100 $$''')
        c.execute('''select p.id as product_id, p.name as product,
                    a.id as additive_id, a.name as additive,
                    ca.quantity additive_in_product,s.id as substance_id,
                    s.ec as substance_ec,s.cas as substance_cas,
                    cs.quantity as substance_in_additive,
                    calculate_concentration(ca.quantity,cs.quantity) as substance_in_product
                    from product p, additive a, substance s,contains_additive ca,
                    contains_substance cs where p.id = ca.product_id and
                    a.id = ca.additive_id and a.id = cs.additive_id and s.id = cs.substance_id
                    order by p.id;''')
        conn.commit()   
    except:
        print("Error while connection to PostgreSQL", err)
        
    finally:
        if (conn):
            c.close()
            conn.close()
    # self delete the script as to not create the schema a second time
    subprocess.Popen("python3 -c \"import os, time; time.sleep(1); os.remove('{}');\"".format(sys.argv[0]),shell=True)
    sys.exit(0)

    
"""
TODO:
# i've currently replaced it with sql text field
# i'll check it later see:https://access.crunchydata.com/documentation/psycopg2/2.7.6/advanced.html#type-casting-from-sql-to-python
c.execute('''create extension plperlu;''')
c.execute('''
    create function valid_email(text)
    returns boolean
    language plperlu
    immutable leakproof strict as
    $$
    use Email::Valid;
    my $email = shift;
    Email::Valid->address($email) or die "Invalid email address: $email\n"; 
    return 'true';
    $$;''')
c.execute('''
    create domain validemail as text not null constraint validemail_check check (valid_email(value));''')
"""


