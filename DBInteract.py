from database import Database
from generate import Generate
import datetime
from dateutil.relativedelta import relativedelta

g = Generate()


class DBInteraction:

    def __init__(self):
        pass

    # ========================= PRODUCT BUTTON ACTIONS ===========================

    @staticmethod
    def add_product(*args):
        args_msds = (args[2], args[-1] if args[-1] != '' else None, (datetime.datetime.now()).strftime('%Y/%m/%d'))
        args_product = args[:-1]

        sql = '''INSERT INTO product (name,grade,code,category,viscosity,company_id,comment)
                values ((%s),(%s),(%s),(%s),(%s),
                (select id from company where name = (%s)),(%s)) on conflict do nothing returning id'''

        sql2 = ''' INSERT INTO msds(product_id, doc, last_check_date) values (
        (select id from product where code = (%s)), (%s), (%s)) on conflict do nothing
        '''
        product_values = [v if v != '' else None for v in args or ()]
        if len(product_values) == 0:
            print('No product given')
            return None

        with Database('msds') as db:
            db.execute(sql, args_product)
            pid = db.fetchone()

            if args_msds[-1] is not None:
                db.execute(sql2, args_msds)

            db.commit()
            if pid == 0:
                return None
            args_product = list(args_product)
            args_product.insert(0, pid)
        return tuple(args_product)

    @staticmethod
    def view_product():
        sql = '''SELECT id, name,grade,code,category,viscosity,
                (select c.name from company c where c.id=company_id) as company,comment 
                 FROM  product'''

        with Database('msds') as db:
            db.execute(sql)
            return db.fetchall()

    @staticmethod
    def delete_product(product_code):
        sql = '''DELETE FROM product WHERE code=(%s) RETURNING * '''
        with Database('msds') as db:
            db.execute(sql, (product_code,))
            deleted = db.fetchall()
            db.commit()
            return deleted

    @staticmethod
    def search_product(code=None, name=None, grade=None, category=None, company=None):
        field = ''
        sql = ''
        if code:
            sql = '''SELECT p.id, p.name,p.grade,p.code, p.category,p.viscosity, (select name from company where
                     p.company_id = id),p.comment FROM product p where p.code like %(field)s escape '=' '''
            field = code
        if name:
            sql = """SELECT p.id, p.name,p.grade,p.code, p.category,p.viscosity, (select name from company where
                     p.company_id = id),p.comment FROM product p where p.name like %(field)s escape '=' """
            field = name
        if grade:
            sql = """SELECT p.id, p.name,p.grade,p.code, p.category,p.viscosity, (select name from company where
                     p.company_id = id),p.comment FROM product p where p.grade like %(field)s escape '=' """
            field = grade
        if category:
            sql = '''SELECT p.id, p.name,p.grade,p.code, p.category,p.viscosity, (select name from company where
                     p.company_id = id),p.comment FROM product p where p.category like %(field)s escape '=' '''
            field = category
        if company:
            sql = ''' select p.id, p.name,p.grade,p.code, p.category,p.viscosity,c.name, p.comment from product p inner join company c 
                      on c.id=p.company_id where c.name like  %(field)s;'''
            field = company
        with Database('msds') as db:
            print(dict(field='%'+field+'%', art="st"))
            db.execute(sql, dict(field='%'+field+'%'))
            return db.fetchall()

    @staticmethod
    def update_product(name='', grade='', code='', category='', viscosity='', company='', comment='', prev_code=''):
        sql = '''update product set name=%s, grade=%s, code=%s, category=%s,
            viscosity=%s, company_id=(select id from company where name=%s),comment=%s where id =%s returning *'''
        sql_company_name = '''select name from company where id=%s'''
        if viscosity == '':
            viscosity = None
        else:
            viscosity = float(viscosity)
        with Database('msds') as db:
            db.execute(sql, (name, grade, code, category, viscosity, company, comment, prev_code))
            updated = db.fetchone()
            db.execute(sql_company_name, (updated[-2],))
            company_name = db.fetchone()
            updated = list(updated)
            updated[-2] = company_name
            db.commit()
            return tuple(updated)

    @staticmethod
    def select_all_companies():
        sql = '''select name from company'''
        with Database('msds') as db:
            db.execute(sql)
            return [v[0] for v in db.fetchall()]

    @staticmethod
    def find_additives(product):
        sql = '''select distinct additive from product_contains_substance
                where product_code =%s'''
        with Database('msds') as db:
            db.execute(sql, (product,))

            return db.fetchall()

    # =========================== ADDITIVE BUTTONS ACTIONS ============================
    @staticmethod
    def add_additive(list_args):
        sql = """INSERT INTO additive (name,last_update_date,price,comment)
        VALUES((%s),(%s),(%s),(%s)) on conflict do nothing
        RETURNING *"""
        if not list_args:
            print('No additives given')
            return None
        add = set()
        new_adds = set()
        for a in list_args:
            new_adds.add(tuple([v if v != '' else None for v in a or ()]))
        with Database('msds') as db:
            for rec in list(new_adds):
                db.execute(sql, rec)
                add.add(db.fetchone())
                db.commit()
        return add

    @staticmethod
    def view_additive():
        sql = '''SELECT * FROM  additive;'''
        with Database('msds') as db:
            db.execute(sql)
            return db.fetchall()

    @staticmethod
    def search_additives_by_product(product_code=""):
        sql= '''SELECT a.* FROM additive AS a where (a.id) in (SELECT DISTINCT pc.additive_id 
        from product_contains_substance as pc where pc.product_code = (%s)) ORDER BY a.name ASC'''
        sql2 = '''SELECT DISTINCT pc.additive, pc.additive_in_product FROM product_contains_substance pc where pc.product_code=(%s)
        and (additive_id) in %s ORDER BY pc.additive ASC'''
        with Database('msds') as db:
            db.execute(sql, (product_code,))
            additives = db.fetchall()
            db.execute(sql2, (product_code, tuple([a[0] for a in additives])))
            res = [a+(b[-1],) for a, b in zip(additives, db.fetchall())]
            return res


    @staticmethod
    def delete_additive(additive_name):
        sql = '''DELETE FROM additive WHERE name=(%s) RETURNING
        name,last_update_date,price,comment'''
        with Database('msds') as db:
            db.execute(sql, (additive_name,))
            deleted = db.fetchall()
            db.commit()
            return deleted

    @staticmethod
    def search_additive(name=None, last_update_date=None, price=None):
        if not last_update_date:
            last_update_date = (datetime.datetime.now()).strftime('%Y/%m/%d')
        else:
            last_update_date = last_update_date.split(' ')[0]
            last_update_date = last_update_date.strip().split('-')
            last_update_date = (datetime.date(int(last_update_date[0]), int(last_update_date[1]), int(last_update_date[2]))).strftime(
                '%Y/%m/%d')
        if not price:
            price = 0.0

        sql = '''SELECT * FROM additive a WHERE a.name like %(name)s escape '=' 
                        AND a.last_update_date < %(last_update_date)s
                        AND a.price > %(price)s'''

        with Database('msds') as db:
            db.execute(sql, dict(name='%' + name + '%', last_update_date=last_update_date, price=price))
            return db.fetchall()

    @staticmethod
    def update_additive(last_update_date='', price='', comment='', prev_name=''):
        sql = '''update additive set last_update_date=%s, price=%s,
            comment=%s where name = (SELECT name from additive where name=%s)
            returning *'''

        if price == '' or price == 'None':
            price = None
        else:
            price = float(price)

        if last_update_date == '' or last_update_date == 'None':
            last_update_date = None

        with Database('msds') as db:
            db.execute(sql, (last_update_date, price, comment, prev_name))
            updated = db.fetchone()
            db.commit()
            return updated

    @staticmethod
    def add_product_additives(product, additives, concentrations):
        sql = ''' insert into contains_additive values ((select p.id from product p where p.code = (%s)),
            (SELECT a.id from additive a where a.name=(%s)), (%s)) on conflict do nothing returning *'''
        prod_add = set()
        for i in range(0, len(additives)):
            prod_add.add((product, additives[i], concentrations[i]))
        added = set()
        with Database('msds') as db:
            for a in prod_add:
                db.execute(sql, a)
                added.add(db.fetchone())
                db.commit()
        return added

    @staticmethod
    def add_additive_substances(additives):
        # where: additives=((additivei, tuple(substanesi),tuple(concentrationsi)),...)
        sql = '''Insert into contains_substance values ((SELECT a.id from additive a where a.name = (%s)), 
        (select s.id from substance s where s.cas = (%s)), (%s)) on conflict do nothing returning *
        '''
        combo = set()
        for i in range(0, len(additives)):
            subs = additives[i][1]
            cons = additives[i][2]
            for j in range(0, len(subs)):
                addsub = (additives[i][0], subs[j], cons[j])
                combo.add(addsub)

        added = set()
        with Database('msds') as db:
            for c in combo:
                db.execute(sql, c)
                added.add(db.fetchone())
                db.commit()
        return added

    @staticmethod
    def select_additive_classification(additive, of_product=False):
        sql = '''select distinct pc.substance_cas, pc.substance_in_additive, c.scl,ghs.code 
        from product_contains_substance pc, classify c inner join ghs ghs on ghs.id=c.ghs_id 
        where pc.substance_id=c.substance_id and pc.additive= (%s) 
        order by pc.substance_cas;'''
        if not of_product:
            sql = '''select s.cas, cs.quantity, c.scl, ghs.code from substance s inner join 
            contains_substance cs on s.id=cs.substance_id inner join classify c 
            on s.id=c.substance_id inner join ghs ghs on ghs.id = c.ghs_id 
            where cs.additive_id = (select id from additive a where a.name= (%s));
            '''
        with Database('msds') as db:
            db.execute(sql, (additive,))
            return db.fetchall()

    # ==============================   REST =======================================

    @staticmethod
    def select_past_due(date_in=None, product_code=None):
        if not date_in:
            date_in = (datetime.datetime.now() - relativedelta(years=1, months=5)).strftime('%Y/%m/%d')
        else:
            date_in = date_in.strip().split('-')
            date_in = (datetime.date(int(date_in[0]),int(date_in[1]),int(date_in[2]))).strftime(
                '%Y/%m/%d')
        sql = ''' select p.code as product, m.msds_no as msds, m.last_check_date as last_updated, m.doc
                from product p left join msds m on p.id=m.product_id
                where m.last_check_date < (%s) order by m.last_check_date'''

        sql2 = '''select p.code as product, m.msds_no as msds, m.last_check_date as last_updated, m.doc
                from product p right join msds m on p.id=m.product_id where m.last_check_date < (%s) 
                and p.code=(%s) order by m.last_check_date'''

        with Database('msds') as db:
            if product_code is not None:
                db.execute(sql2, (date_in,product_code))
                return db.fetchall()
            else:
                db.execute(sql,(date_in,))
                return db.fetchall()

    @staticmethod
    def select_all():
        sql = '''SELECT * FROM product_contains_substance'''
        with Database('msds') as db:
            db.execute(sql)
            all_prods = db.fetchall()
            db.commit()
        return all_prods

    @staticmethod
    def select_classification(productcode, additives=None):  # args = (additivecode,(substancescas))
        sql = '''select pc.substance_cas, pc.substance_in_product, 
            c.scl,ghs.code from product_contains_substance pc,
            classify c inner join ghs ghs on ghs.id=c.ghs_id
            where pc.substance_id=c.substance_id
            and pc.additive=(%s) and pc.substance_cas = (%s) and
            pc.product_id = (select p.id from product p where p.code=(%s)) order by pc.substance_cas;
            '''
        sql2 = '''select pc.additive, pc.additive_in_product, pc.substance_cas, pc.substance_in_product,
            ghs.code, c.scl, ghs.hazard_class, ghs.category from product_contains_substance pc,
            classify c inner join ghs ghs on ghs.id=c.ghs_id
            where pc.substance_id=c.substance_id
            and pc.product_id = (select p.id from product p where p.code=(%s))
            order by pc.additive,pc.substance_cas;
            '''

        combo = set()
        results = dict()
        for i in range(0, len(additives or ())):
            substances = additives[i][1]
            for j in substances:
                addsub = (additives[i][0], j, productcode)
                combo.add(addsub)
        with Database('msds') as db:
            if not additives:
                db.execute(sql2, (productcode,))
                return db.fetchall()
            else:
                for i in combo:
                    db.execute(sql, i)
                    results[i[1]] = db.fetchall()
                return results

    @staticmethod
    def filter_classification(prcode='', filter_code='',filter_category=''):
        sql = '''select pc.additive, pc.substance_cas, pc.substance_in_product,
            ghs.code, c.scl, ghs.hazard_class, ghs.category from product_contains_substance pc,
            classify c inner join ghs ghs on ghs.id=c.ghs_id
            where pc.substance_id=c.substance_id
            and pc.product_id = (select p.id from product p where p.code=%(pcode)s) 
            and ghs.code like %(hcode)s escape '=' and ghs.category like %(category)s escape '='
            order by pc.additive,pc.substance_cas;
            '''
        with Database('msds') as db:
            db.execute(sql, dict(pcode=prcode, hcode='%' + filter_code, category='%' + filter_category))
            return db.fetchall()

    @staticmethod
    def find_pcodes(ghs_code = ''):
        sql = '''select p.code, p.message from (p_statement p inner join has_pcode hs on p.code = hs.p_code)
        inner join ghs on hs.ghs_id = ghs.id where ghs.code = (%s)'''

        with Database('msds') as db:
            db.execute(sql, (ghs_code,))
            return db.fetchall()

#test
#geaega dageaa
#990906-64-7,977263-57-1,51790-76-2,685237-59-2
#12,14,11,15
