from generate import Generate   #from file import class
import random
import datetime
class Data:  
    def __init__(self, **kwargs):
        self.additives_f = ''
        self.substances_f = ''
        self.products_f = ''
        self.companies_f = ''
        self.statements_f = ''
        self.pcodes_f = ''
        self.ghs_f = ''
        if kwargs.get('additives'):
            self.additives_f = kwargs['additives']
        if kwargs.get('substances'):
            self.substances_f = kwargs['substances']
        if kwargs.get('products'):
            self.products_f = kwargs['products']
        if kwargs.get('companies'):
            self.companies_f = kwargs['companies']
        if kwargs.get('statements'):
            self.statements_f = kwargs['statements']
        if kwargs.get('pcodes'):
            self.pcodes_f = kwargs['pcodes']
        if kwargs.get('ghs'):
            self.ghs_f = kwargs['ghs']

    @classmethod
    def move_one(self,line):
        try:
            line[6]+=", "
            for i in range(7, len(line)):
                line[6] += line[i] + ", "
            line[6] =  line[6][:len(line[6])-2]
        except IndexError:
            line.append('None')

        return line[:7]

    '''################# FOR COMPANY #####################'''
    
    def company(self):
        company_info = dict()
        try:
            with open(self.companies_f,'r') as comp:
                headers = next(comp)
                companies = comp.read().strip().split('\n')
                counter = 1
                for comp in companies:
                    c =  comp.strip().split('\t')
                    company_info.update({counter:{
                            'name':c[0],
                            'email':c[1],
                            'phone':c[2],
                            'address':c[3],
                            'zip':c[4],
                            'city':c[5],
                            'country':c[6]
                    }})
                    counter += 1
        except FileNotFoundError:
            if (self.companies_f == ''):
                print('No file name given while creating Data Object')
            else:
                print('No such file or directory: ' + self.companies_f)
    
        return company_info


    '''################# FOR GHS #####################'''
      
    def ghs(self):
        ghs = dict()
        # create ghs pictogram ids
        pic_ids = "1;1;1;1;1;None;2;2;2;2;2;2;None;2;2;2;2;2;None;2;2;2;2;None;2;2;2;1;1;2;2;2;2;2;2;2;2;2;2;3;3;3;3;4;4;2,4;2,4;4;5;6;6;6;7;None;8;8;6;6;6;7;None;5;7;7;7;7;None;7;5;5;5;7;None;6;6;6;7;None;8;7;7;7;7;8;8;8;8;8;8;8;8;8;8;8;8;8;8;8;8;8;;8;8;8;8;8;8;None;8;8;8;8;9;None;None;9;9;None;None;7;6;6;6;6;6;6;6;6;7;7;7;7;None;None;None;None;7"
        pic_ids = pic_ids.split(";")
        for i in pic_ids:
            if i!='None':
                pic_ids[pic_ids.index(i)] = "GHS"+i
        try:
            with open(self.ghs_f, 'r') as f:
                headers = next(f)
                counter = 0
                for line in f:
                    line = line.strip().split('\t')
                    line.insert(4,pic_ids[counter])
                    line = self.move_one(line)
                    counter += 1
                    ghs.update({counter:{
                        'code': line[0],
                        'hazard_statement':line[1],
                        'hazard_class': line[2],
                        'category': line[3],
                        'pictogram_id': line[4],
                        'signal_word': line[5],
                        'p_codes': line[6]}})
        except FileNotFoundError:
            if (self.ghs_f == ''):
                print('No file name given while creating Data Object')
            else:
                print('No such file or directory: ' + self.ghs_f)
        return ghs


    ''' ############ FOR PRECAUTIONARY STATEMENTS ###########'''

    
    def p_statement(self):
        p_statement = dict()
        try:
            with open(self.pcodes_f, 'r') as pcodes:
                for pc in pcodes.readlines():
                    code,msg = pc. strip().split('\t')
                    p_statement.update({code:msg})
        except FileNotFoundError:
            if (self.pcodes_f == ''):
                print('No file name given while creating Data Object')
            else:
                print('No such file or directory: ' + self.pcodes_f)
        return p_statement


    def has_pcode(self):
        ghs = self.ghs()
        has_pcode = set()
        for ghs_id, info in ghs.items():
            pcodes = info.get('p_codes').split(', ')
            if ghs_id > 99:
                hazards = info.get('code').split('+')
                composite_h = list()
                for h in hazards:
                    ghs_of_h = [k for k in ghs.keys() if ghs[k].get('code') == h]
                    composite_h.extend(ghs[ghs_of_h[0]].get('p_codes').split(', '))
                pcodes = list(set(composite_h))
            for p in pcodes:
                has_pcode.add((ghs_id, p))
        return has_pcode


    ''' ############ FOR PRODUCTS ###########'''
    def product(self):
        products = dict()
        companies = self.company()
        try:
            with open(self.products_f,'r') as p:
                headers = next(p).strip().split(',')
                for product in p.readlines():
                    pr = product.strip().split(',')
                    products.update({int(pr[0]):{
                        'name':pr[1],
                        'grade': pr[2],
                        'code': pr[3],
                        'category': pr[4],
                        'viscosity': float(pr[5]),
                        'company_id': random.choice(list(companies.keys()))
                    }})
        except FileNotFoundError:
            if (self.products_f == ''):
                print('No file name given while creating Data Object')
            else:
                print('No such file or directory: ' + self.products_f)
        return products


    def msds(self):
        g = Generate()
        msds = dict()
        products = self.product()
        for i in range(100):
            date = [int(i) for i in g.date('EU').split('/')[::-1]]
            msds.update({i+1: {
                'product_id': random.choice(list(products.keys())),
                'last_check_date': datetime.date(date[0],date[1],date[2]),
                'doc_path':  f'msds_docs\\msds{i+1}.docx'
                }})
        return msds


    def standard(self):
        products = self.product()
        standards = set()
        try:
            with open(self.statements_f, 'r') as sts:
                for line in sts.readlines():
                    st_name = line.strip()
                    for i in range(random.randint(3,7)):
                        standards.add((random.choice(list(products.keys())),st_name))
        except FileNotFoundError:
            if (self.statements_f == ''):
                print('No file name given while creating Data Object')
            else:
                print('No such file or directory: ' + self.statements_f)
        return standards




    '''################# FOR SUBSTANCES #####################'''


    def substance(self):
        substances = dict()
        g = Generate()
        try:
            with open(self.substances_f,'r') as subs:
                headers = next(subs)
                counter = 1
                for s in subs:
                    s = s.strip().split(',')
                    s[5] = g.date('EU')
                    s[6] = g.date('EU')
                    #converts dates to int values, to be used with the datetime class
                    lmdate = [int(i) for i in s[5].split('/')[::-1]]
                    lcdate = [int(i) for i in s[6].split('/')[::-1]]
                    substances.update({counter:{
                        'ec': g.ec(),
                        'cas': g.cas(),
                        'name': s[0],
                        'reach': g.reach(),
                        'ghs':s[1].split(':'),
                        'scl':s[2].split(':'),
                        'adr':s[4],
                        'pbt':s[3],
                        'last_mod_date': datetime.date(lmdate[0],lmdate[1],lmdate[2]),
                        'last_check_date':datetime.date(lcdate[0],lcdate[1],lcdate[2])
                        }})
                    counter += 1
        except FileNotFoundError:
            if (self.substances_f == ''):
                print('No file name given while creating Data Object')
            else:
                print('No such file or directory: ' + self.substances_f)
        return substances

    
    def retrieve_allsubs_ghs(self):
        sub_ghs = dict()
        ghs_codes_only = [v.get('code') for v in self.ghs().values()]
        substances = self.substance()
        for sub,v in substances.items():
            item_codes = v.get('ghs')
            scl = v.get('scl')
            if len(scl) == 1:
                scl = ['' for i in range(len(item_codes))]
            v_codes = []
            scls = []
            for hcode in ghs_codes_only:
                for h in item_codes:
                    if hcode == h.split(' ')[0]:
                        scl_index = item_codes.index(h)
                        v_codes.append(hcode)
                        scls.append(scl[scl_index])
                        sub_ghs.update({sub:{'codes':v_codes,'scl':scls}})
        return sub_ghs


    def classify(self):
        classify = set()
        substances = self.substance()
        ghs = self.ghs()
        for sub, haz in self.retrieve_allsubs_ghs().items():
            codes = haz.get('codes')
            scl = haz.get('scl')
            for i in range(len(codes)):
                 temp_scl = scl[i]
                 if temp_scl == '':
                     temp_scl = None
                 elif temp_scl.strip(' ').startswith('M'):
                     temp_scl = float(temp_scl.split('=')[-1].strip(' '))
                 else:
                     temp_scl = float(temp_scl.split(' ')[-1].strip(' ').rstrip('%'))
                 key_code = 0
                 for k,v in ghs.items(): # find the key
                     if v.get('code') == codes[i]:
                        key_code = k
                 classify.add((sub,key_code ,temp_scl))
        return classify


    '''################# FOR BASES #####################'''

    def base(self):
        bases = dict()
        base_name = ['MOH SN-90', 'MOH SN-150', 'MOH SN-500', 'BRIGHT STOCK']
        for i in range(1,5):
             bases.update({i:{
                 'code': base_name[i-1],
                 'vi_40': round(random.uniform(1.1,50.0),2),
                 'vi_100': round(random.uniform(15.0, 600.0),2),
                 'qqsp_gr': round(random.uniform(0.0,0.9999),3),
                 'price': round(random.uniform(5,20),2)}})
        return bases


    def contains_base(self):
        contains_base = dict()
        product = self.product()
        base = self.base()
        for i in range(150):    
            contains_base.update({(random.choice(list(product.keys())),\
                            random.choice(list(base.keys()))):\
                                  round(random.uniform(5,40),2)})
        return contains_base



    '''################# FOR ADDITIVES #####################'''


    def additive(self):
        additives = dict()
        try:
            with open(self.additives_f, 'r') as add:
                headers = next(add)
                counter = 1
                for line in add.readlines():
                    additive = line.strip().split(',')
                    date = [int(i) for i in additive[3].split('/')[::-1]]
                    additives.update({counter:{
                        'name': additive[0],
                        'last_update_date': datetime.date(date[0],date[2],date[1]),
                        'price': round(random.uniform(5,15),2)}})
                    counter += 1
        except FileNotFoundError:
            if (self.additives_f == ''):
                print('No file name given while creating Data Object')
            else:
                print('No such file or directory: ' + self.additives_f)
        return additives


    def contains_additive(self):
        contains_add = dict()
        products = self.product()
        additives = self.additive()
        for i in range(100):  # as many as in contains_base
            contains_add.update({(random.choice(list(products.keys())),\
                          random.choice(list(additives.keys()))):\
                          round(random.uniform(5,30),2)})
        return contains_add


    def contains_substance(self):
        contains_sub = dict()
        subs = self.substance()
        additives = self.additive()
        for i in range(100):  # as many as in contains_base
            contains_sub.update({(random.choice(list(additives.keys())),\
                              random.choice(list(subs.keys()))):\
                              round(random.uniform(5,35),4)})
        return contains_sub


'''
CREATE A VIEW THAT CONTAINS ALL THE SUBSTANCES A PRODUCT HAS,
INCLUDING THEIR QUANTITIES
'''
      