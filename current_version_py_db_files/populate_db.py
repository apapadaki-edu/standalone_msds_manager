from data import Data
import psycopg2


data = Data(additives='resources/additives.csv',
            substances='resources/substancies.csv',
            products='resources/products',
            companies='resources/companies.txt',
            statements='resources/sts',
            pcodes='resources/p_codes.txt',
            ghs='resources/ghs.txt')


companies = data.company()           
def insert_companies(companies_dict):
    sql = """INSERT INTO company (name,email,phone,address,zip,city,country)
    VALUES(%(name)s,%(email)s,%(phone)s,%(address)s,%(zip)s,%(city)s,%(country)s)
    RETURNING id"""

    companies = tuple(companies_dict.values())
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,companies)
        conn.commit() 
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


products = data.product()
def insert_products(products_dict):
    sql = """INSERT INTO product (name,grade,code,category,viscosity,company_id)
    VALUES(%(name)s,%(grade)s,%(code)s,%(category)s,%(viscosity)s,%(company_id)s)
    RETURNING id"""
    products = tuple(products_dict.values())
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,products)
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


additives = data.additive()
def insert_additives(additives_dict):
    sql = """INSERT INTO additive (name,last_update_date,price)
    VALUES(%(name)s,%(last_update_date)s,%(price)s)
    RETURNING id"""
    additives = tuple(additives_dict.values())
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,additives)
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


ghs = data.ghs()
def insert_ghs(ghs_dict):
    sql = """INSERT INTO ghs (code,hazard_statement,hazard_class,category,pictogram_id,signal_word)
    VALUES(%(code)s,%(hazard_statement)s,%(hazard_class)s,%(category)s,%(pictogram_id)s,%(signal_word)s)
    RETURNING id"""
    ghs = tuple(ghs_dict.values())
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,ghs)
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL" )
        
    finally:
        if (conn):
            c.close()
            conn.close()


bases = data.base()
def insert_bases(bases_dict):
    sql = """INSERT INTO base (code,vi_40,vi_100,qqsp_gr,price)
    VALUES(%(code)s,%(vi_40)s,%(vi_100)s,%(qqsp_gr)s,%(price)s)"""
    bases = tuple(bases_dict.values())
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,bases)
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


substances = data.substance()

def insert_substances(subs_dict):
    sql = """INSERT INTO substance (ec,cas,name,reach,un_number,pbt,last_mod_date,last_check_date)
    VALUES(%(ec)s,%(cas)s,%(name)s,%(reach)s,%(adr)s,%(pbt)s,%(last_mod_date)s,%(last_check_date)s)
    RETURNING id"""
    
    for k, substance in subs_dict.items():
        substance.pop('ghs')
        substance.pop('scl')
        s = [x if x != '-' else None for x in substance.values()]
        subs_dict[k].update({'ec': s[0],'cas':s[1],'name':s[2],'reach':s[3], 'adr':s[4],'pbt':s[5],'last_mod_date':s[6],'last_check_date':s[7]})
    substances = tuple(subs_dict.values())
    
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,substances)
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


standards = data.standard()
def insert_standards(standard_set):
    sql = """INSERT INTO standard (product_id,name)
    VALUES(%s,%s)"""
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,list(standard_set))
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


msds = data.msds()
def insert_msds(msds_dict):
    sql = """INSERT INTO msds (product_id,last_check_date,doc)
    VALUES(%(product_id)s,%(last_check_date)s,%(doc_path)s)"""
    msds = tuple(msds_dict.values())
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql, msds)
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


p_stmt = data.p_statement()
def insert_p_statements(p_stmt_dict):
    sql = """INSERT INTO p_statement (code,message)
    VALUES(%s,%s)"""
    p_statements = set()
    for k,v in p_stmt_dict.items():
        p_statements.add((k,v))
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,list(p_statements))
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


classification = data.classify()
def insert_classification(classifications):
    sql = """INSERT INTO classify (substance_id,ghs_id,scl)
    VALUES(%s,%s,%s)"""
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,list(classifications))
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


pcodes = data.has_pcode()
def insert_pcodes(pcodes_set):
    sql = """INSERT INTO has_pcode (ghs_id,p_code)
    VALUES(%s,%s)"""
    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,list(pcodes_set))
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


c_base = data.contains_base()
def insert_c_base(c_base_dict):
    sql = """INSERT INTO contains_base (product_id, base_id, quantity)
    VALUES(%s,%s,%s)"""
    c_bases = set()
    for k in c_base_dict.keys():
        c_bases.add((k[0], k[1], c_base_dict.get(k)))

    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,list(c_bases))
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()

c_additive = data.contains_additive()
def insert_c_additive(c_add_dict):
    sql = """INSERT INTO contains_additive (product_id, additive_id, quantity)
    VALUES(%s,%s,%s)"""
    c_additives = set()
    for k in c_add_dict.keys():
        c_additives.add((k[0], k[1], c_add_dict.get(k)))

    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,list(c_additives))
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()



c_substance = data.contains_substance()
def insert_c_substance(c_sub_dict):
    sql = """INSERT INTO contains_substance (additive_id, substance_id, quantity)
    VALUES(%s,%s,%s)"""
    c_substances = set()
    for k in c_sub_dict.keys():
        c_substances.add((k[0], k[1], c_sub_dict.get(k)))

    try:
        conn = psycopg2.connect(database= "msds", user="postgres",password="12345678",host="127.0.0.1",port="5432")
        c = conn.cursor()
        c.executemany(sql,list(c_substances))
        conn.commit()
    except:
        print("Error while connecting to PostgreSQL")
        
    finally:
        if (conn):
            c.close()
            conn.close()


if __name__=='__main__':
    insert_companies(companies)
    insert_products(products)
    insert_additives(additives)
    insert_ghs(ghs)
    insert_bases(bases)
    insert_substances(substances)
    insert_standards(standards)
    insert_msds(msds)
    insert_p_statements(p_stmt)
    insert_classification(classification)
    insert_pcodes(pcodes)
    insert_c_base(c_base)
    insert_c_additive(c_additive)
    insert_c_substance(c_substance)
