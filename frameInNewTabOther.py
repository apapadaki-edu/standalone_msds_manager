import tkinter as tk
from tkinter import messagebox
from tkinter.filedialog import askopenfile


class Page(tk.Frame):
    def __init__(self, *args, **kwargs):
        tk.Frame.__init__(self, *args, **kwargs)

    def show(self):
        self.lift()

    def open_file(self):
        file_path = askopenfile(mode='r')
        if file_path is not None:
            pass

    def exit(self):
        Exit = messagebox.askyesno('Classification Management', 'Confirm exit')
        if Exit > 0:
            root.destroy()
            return


class Page1(Page):
    def __init__(self, *args, **kwargs):
        Page.__init__(self, *args, **kwargs)

        self.date_value = tk.StringVar()

        pmain = tk.Frame(self, bg='#0d4357')
        pmain.pack(side=tk.TOP, pady=10, expand=True)

        title_pmain = tk.Frame(pmain, bd=2, padx=10, pady=8, bg='white', relief=tk.RIDGE)
        title_pmain.pack(side=tk.TOP, fill=tk.X, ipadx=10, pady=10)

        self.title = tk.Label(title_pmain, font=('calibre', 30, 'bold'), text='Take A Peek', bg='white')
        self.title.grid(row=0, column=0, sticky='we')
        self.title = tk.Label(title_pmain, font=('calibre', 30, 'bold'), bg='white')
        self.title.grid(row=0, column=1, ipadx=160, sticky='we')
        self.date_label = tk.Label(title_pmain, font=('calibre', 15, 'bold'), text='Date due:', bg='white')
        self.date_label.grid(row=0, ipadx=10, column=2, sticky='e')
        self.date = tk.Entry(title_pmain, font=('calibre', 15, 'bold'), bg='white', textvariable=self.date_value)
        self.date.grid(row=0, column=3, sticky='e')
        self.submit = tk.Button(title_pmain, font=('calibre', 12), height=1, width=10, bd=2, relief=tk.RIDGE,
                                text='Display')
        self.submit.grid(row=0, column=4, padx=10, sticky='e')
        Exit = tk.Button(title_pmain, text='Exit', font=('calibre', 12), height=1, width=10, bd=2, relief=tk.RIDGE,
                         command=lambda: Page.exit(self))
        Exit.grid(row=0, column=5, padx=10, sticky='e')

        data_pmain = tk.Frame(pmain, width=1300, height=600, bd=1, bg='#48526b', relief=tk.RIDGE)
        data_pmain.pack(side=tk.BOTTOM, fill=tk.BOTH, ipadx=2)

        data_pmain_left = tk.LabelFrame(data_pmain, width=500, height=600, bd=1, pady=10, bg='white', relief=tk.RIDGE,
                                        font=('calibre', 20, 'bold'), text='Intro\n')
        data_pmain_left.pack(side=tk.LEFT, fill=tk.BOTH, ipadx=30)

        pmain_title = tk.LabelFrame(data_pmain, bd=1, width=1000, height=600, padx=5, pady=3, bg='white',
                                    relief=tk.RIDGE, font=('calibre', 20, 'bold'), text='Up to Task')
        pmain_title.pack(side=tk.RIGHT, fill=tk.BOTH, ipadx=10)

        text = '''aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'''
        description = tk.Label(data_pmain_left, font=('calibre', 12), text=text, bg='white', wraplength=450,
                               justify=tk.LEFT)
        description.grid(row=0, column=0, padx=30, sticky='wens')

        scrollbar = tk.Scrollbar(pmain_title)
        scrollbar.grid(row=0, column=1, sticky='ns')

        product_list = tk.Listbox(pmain_title, width=105, height=30, font=('calibre', 12), yscrollcommand=scrollbar.set)
        product_list.grid(row=0, column=0, padx=3)
        scrollbar.config(command=product_list.yview)


class Page2(Page):
    def __init__(self, *args, **kwargs):
        Page.__init__(self, *args, **kwargs)

        # ======================================= VARIABLES =====================================

        self.pr_code = tk.StringVar()
        self.pr_name = tk.StringVar()
        self.pr_grade = tk.StringVar()
        self.pr_category = tk.StringVar()
        self.pr_viscosity = tk.DoubleVar()
        self.pr_company = tk.IntVar()
        self.pr_comment = tk.StringVar()

        self.msds = tk.StringVar()
        self.date = tk.StringVar()

        # ======================================= FUNCTIONS ========================================


        def clear_data(self):
            code.delete(0, tk.END)
            name.delete(0, tk.END)
            grade.delete(0, tk.END)
            category.delete(0, tk.END)
            viscosity.delete(0, tk.END)
            company.delete(0, tk.END)
            comment.delete(0, tk.END)
            date.delete(0, tk.END)

        def add_data(self):
            global new_pr_date
            new_pr_date = date.get()

            if len(code.get()) != 0:

                companies = dbi.select_all_companies()
                if len(company.get()) != 0 and (company.get() in companies):

                    product = dbi.add_product(name.get(), grade.get(), code.get(), \
                                              category.get(), viscosity.get(), company.get())
                    product_list.delete(0, tk.END)
                    product_list.insert(tk.END, 'Name, Grade, Category, Viscosity, CompanyID, Comment')

                    if product is not None:
                        product_list.insert(tk.END, product)
                    else:
                        product_list.insert(tk.END, 'Product already exists!')
                else:
                    product_list.delete(0, tk.END)
                    product_list.insert(tk.END, 'Wrong company name or empty company field!')
                    product_list.insert(tk.END, 'It can only be one of the following:')
                    for c in companies:
                        product_list.insert(tk.END, c)

        def display_data(self):
            product_list.delete(0, tk.END)
            counter = 1
            for p in dbi.view_product():
                product_list.insert(tk.END, 'ID, Name, Grade, Category, Viscosity, CompanyID, Comment')
                product_list.insert(tk.END, p)

        def product_record(event):
            global pr
            search_product = product_list.curselection()[0]
            pr = product_list.get(search_product)

            name.delete(0, tk.END)
            name.insert(tk.END, pr[3])
            grade.delete(0, tk.END)
            grade.insert(tk.END, pr[2])
            code.delete(0, tk.END)
            code.insert(tk.END, pr[1])
            category.delete(0, tk.END)
            category.insert(tk.END, pr[4])
            viscosity.delete(0, tk.END)
            viscosity.insert(tk.END, pr[5])
            company.delete(0, tk.END)
            company.insert(tk.END, pr[6])
            comment.delete(0, tk.END)
            comment.insert(tk.END, pr[7])

        def delete_data(self):
            product_list.delete(0, tk.END)
            if len(code.get()) != 0:
                dbi.delete_product(pr[3])
                clear_data(self)
                display_data(self)

        def search_data(self):
            product_list.delete(0, tk.END)
            for p in dbi.search_product(name.get(), grade.get(), code.get(), \
                                        category.get(), viscosity.get(), company.get()):
                product_list.insert(tk.END, p)

        def update_data(self):
            if len(code.get()) != 0:
                product = dbi.update_product(name.get(), grade.get(), code.get(), \
                                             category.get(), viscosity.get(), company.get(), (list(pr))[0])
                product_list.delete(0, tk.END)
                product_list.insert(tk.END, product)

        # ======================================= FRAMES ========================================

        pmain = tk.Frame(self, bg='#0d4357')
        pmain.pack(side=tk.TOP, pady=10, expand=True)

        title_pmain = tk.Frame(pmain, bd=2, padx=10, pady=8, bg='white', relief=tk.RIDGE)
        title_pmain.pack(side=tk.TOP, fill=tk.X, ipadx=10, pady=10)

        self.title = tk.Label(title_pmain, font=('calibre', 30, 'bold'), text='Products Management', bg='white')
        self.title.grid(sticky='we')

        button_pmain = tk.Frame(pmain, width=1750, height=70, bd=2, padx=18, pady=10, bg='white', relief=tk.RIDGE)
        button_pmain.pack(side=tk.BOTTOM, pady=10, fill=tk.X)

        data_pmain = tk.Frame(pmain, width=1300, height=600, bd=1, bg='#48526b', relief=tk.RIDGE)
        data_pmain.pack(side=tk.BOTTOM, fill=tk.BOTH, ipadx=2)

        data_pmain_left = tk.LabelFrame(data_pmain, width=500, height=600, bd=1, pady=3, bg='white', relief=tk.RIDGE,
                                        font=('calibre', 20, 'bold'), text='Product Information\n')
        data_pmain_left.pack(side=tk.LEFT, fill=tk.BOTH, ipadx=30)

        pmain_title = tk.LabelFrame(data_pmain, bd=1, width=1000, height=600, padx=5, pady=3, bg='white',
                                    relief=tk.RIDGE,
                                    font=('calibre', 20, 'bold'), text='Product Details\n')
        pmain_title.pack(side=tk.RIGHT, fill=tk.BOTH, ipadx=10)

        # ======================================= DATA ENTRIES  ========================================
        code_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Code:')
        name_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Name:')
        grade_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Grade:')
        category_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Category:')
        viscosity_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Viscosity:')
        company_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Company:')
        comment_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Comment:')
        separator_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='\nData Sheet Information\n')
        msds_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='MSDS:')
        date_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Last Updated:')

        code = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.pr_code)
        name = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.pr_name)
        grade = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.pr_grade)
        category = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.pr_category)
        viscosity = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.pr_viscosity)
        company = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.pr_company)
        comment = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.pr_comment)
        msds = tk.Button(data_pmain_left, width=30, font=('calibre', 15), text='Choose file',
                         relief=tk.RIDGE, command=Page.open_file, state=tk.DISABLED)
        date = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.date)

        code_label.grid(row=4, column=0, padx=2, pady=10, sticky=tk.W)
        name_label.grid(row=5, column=0, padx=2, pady=10, sticky=tk.W)
        grade_label.grid(row=6, column=0, padx=2, pady=10, sticky=tk.W)
        category_label.grid(row=7, column=0, padx=2, pady=10, sticky=tk.W)
        viscosity_label.grid(row=8, column=0, padx=2, pady=10, sticky=tk.W)
        company_label.grid(row=9, column=0, padx=2, pady=10, sticky=tk.W)
        comment_label.grid(row=10, column=0, padx=2, pady=10, sticky=tk.W)
        separator_label.grid(row=11, column=0, padx=2, pady=10, columnspan=2, sticky=tk.W)
        msds_label.grid(row=12, column=0, padx=2, pady=10, sticky=tk.W)
        date_label.grid(row=13, column=0, padx=2, pady=10, sticky=tk.W)

        code.grid(row=4, column=1, ipadx=2, ipady=2)
        name.grid(row=5, column=1, ipadx=2, ipady=2)
        grade.grid(row=6, column=1, ipadx=2, ipady=2)
        category.grid(row=7, column=1, ipadx=2, ipady=2)
        viscosity.grid(row=8, column=1, ipadx=2, ipady=2)
        company.grid(row=9, column=1, ipadx=2, ipady=2)
        comment.grid(row=10, column=1, ipadx=2, ipady=2)
        msds.grid(row=12, column=1, ipadx=2, ipady=2)
        date.grid(row=13, column=1, ipadx=2, ipady=2)

        # ======================================= SCROLLBAR ========================================
        scrollbar = tk.Scrollbar(pmain_title)
        scrollbar.grid(row=0, column=1, sticky='ns')

        product_list = tk.Listbox(pmain_title, width=105, height=30, font=('calibre', 12), yscrollcommand=scrollbar.set)
        product_list.bind('<<ListboxSelect>>', product_record)
        product_list.grid(row=0, column=0, padx=3)
        scrollbar.config(command=product_list.yview)

        # ======================================= BUTTONS ========================================

        add = tk.Button(button_pmain, text='Add new', font=('calibre', 12), height=1, width=10, bd=2,
                        relief=tk.RIDGE, command=lambda:add_data(self))
        add.grid(row=0, column=0, padx=10)

        display = tk.Button(button_pmain, text='Display', font=('calibre', 12), height=1, width=10, bd=2,
                            relief=tk.RIDGE, command=lambda:display_data(self))
        display.grid(row=0, column=1, padx=10)

        clear = tk.Button(button_pmain, text='Clear', font=('calibre', 12), height=1, width=10, bd=2,
                          relief=tk.RIDGE, command=lambda:clear_data(self))
        clear.grid(row=0, column=2, padx=10)

        delete = tk.Button(button_pmain, text='Delete', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE, command=lambda:delete_data(self))
        delete.grid(row=0, column=3, padx=10)

        search = tk.Button(button_pmain, text='Search', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE, command=lambda:search_data(self))
        search.grid(row=0, column=4, padx=10)

        update = tk.Button(button_pmain, text='Update', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE, command=lambda:update_data(self))
        update.grid(row=0, column=5, padx=10)

        Exit = tk.Button(button_pmain, text='Exit', font=('calibre', 12), height=1, width=10, bd=2,
                         relief=tk.RIDGE, command=lambda: Page.exit(self))
        Exit.grid(row=0, column=6, padx=10)

    # ======================================= FUNCTIONS ========================================


class Page3(Page):
    def __init__(self, *args, **kwargs):
        checked = kwargs.pop('title')
        Page.__init__(self, *args, **kwargs)

        # ======================================= VARIABLES =====================================
        dict_adds = dict()
        self.name = tk.StringVar()
        self.date = tk.StringVar()
        self.concentration = tk.DoubleVar()
        self.price = tk.DoubleVar()
        self.substances = tk.StringVar()
        self.msds = tk.StringVar()
        self.comment = tk.StringVar()
        self.substances = tk.StringVar()
        self.contained = tk.StringVar()
        self.pr_code = tk.StringVar()

        # ======================================= FUNCTIONS ========================================

        def clear_data(self):
            name.delete(0, tk.END)
            date.delete(0, tk.END)
            concentration.delete(0, tk.END)
            concentration.insert(tk.END, 0.0)
            price.delete(0, tk.END)
            price.insert(tk.END, 0.0)
            substances.delete(0, tk.END)
            comment.delete(0, tk.END)
            contained.delete(0, tk.END)

        def add_one(self):
            n = name.get()
            d = date.get()
            c = concentration.get()
            p = price.get()
            s = substances.get().strip().split(',')
            com = comment.get()
            con = contained.get().strip().split(',')
            dict_adds.update({n: {'info': [d, p, com],
                                  'concentration': c,
                                  'subs': s,
                                  'cons': [float(c) for c in con]
                                  }})
            name.focus_set()
            clear_data(self)
            additive_list.insert(tk.END, dict_adds.get(n))

        def add_data(self):
            # 332491-18-3,536722-82-0   12.4, 45.6  712393-16-0    25.6
            all_additives = set()
            all_substances = set()
            additive = list()
            substance = tuple()
            concentrations = list()
            for k, v in dict_adds.items():
                additive.append(k)
                concentrations.append(v.get('concentration'))
                info = v.get('info')
                for i in list(info):
                    additive.append(i)
                all_additives.add(tuple(additive))
                additive = list()
                substance = (k, tuple(v.get('subs')), tuple(v.get('cons')))
                all_substances.add(substance)

            # add additive
            added = dbi.add_additive(list(all_additives))
            additive_list.delete(0, tk.END)
            for a in added:
                additive_list.insert(tk.END, a)

            # add additive substances
            additive_substance_list.delete(0, tk.END)
            for s in dbi.add_additive_substances(tuple(all_substances)):
                additive_substance_list.insert(tk.END, s)

            # add product additives
            additive_names = tuple(dict_adds.keys())
            dbi.add_product_additives(pr_code.get(), additive_names, tuple(concentrations))
            pr_code.delete(0, tk.END)
            dict_adds.clear()

        def display_data(self):
            additive_list.delete(0, tk.END)
            additive_substance_list.delete(0, tk.END)
            for p in dbi.view_additive():
                additive_list.insert(tk.END, p)
            if len(name.get()) != 0:
                additive_substance_list.insert(tk.END, 'CAS, CONCENTRATION, SCL, GHS', '')
                subs = dbi.select_additive_classification(name.get())
                for s in subs:
                    additive_substance_list.insert(tk.END, s)

        def additive_record(event):
            global pr
            search_additive = additive_list.curselection()[0]
            pr = additive_list.get(search_additive)

            name.delete(0, tk.END)
            name.insert(tk.END, pr[1])
            date.delete(0, tk.END)
            date.insert(tk.END, pr[2])
            price.delete(0, tk.END)
            price.insert(tk.END, pr[3])
            comment.delete(0, tk.END)
            comment.insert(tk.END, pr[4])

        def delete_data(self):
            additive_list.delete(0, tk.END)
            if len(name.get()) != 0:
                dbi.delete_additive(pr[1])
                clear_data(self)
                display_data(self)

        def search_data(self):
            additive_list.delete(0, tk.END)
            for p in dbi.search_additive(name.get(), date.get(), \
                                         price.get(), comment.get()):
                additive_list.insert(tk.END, p)

        def update_data(self):

            if len(name.get()) != 0:
                additive = dbi.update_additive(date.get(), price.get(), comment.get(), pr[1])
                additive_list.delete(0, tk.END)
                additive_list.insert(tk.END, additive)

        # ======================================= FRAMES ========================================

        pmain = tk.Frame(self, bg='#0d4357')
        pmain.pack(side=tk.TOP, pady=10, expand=True)

        title_pmain = tk.Frame(pmain, bd=2, padx=10, pady=8, bg='white', relief=tk.RIDGE)
        title_pmain.pack(side=tk.TOP, fill=tk.X, ipadx=10, pady=10)

        self.title = tk.Label(title_pmain, font=('calibre', 30, 'bold'), text='Additives Management', bg='white')
        self.title.grid(sticky='we')

        button_pmain = tk.Frame(pmain, width=1750, height=70, bd=2, padx=18, pady=10, bg='white', relief=tk.RIDGE)
        button_pmain.pack(side=tk.BOTTOM, pady=10, fill=tk.X)

        data_pmain = tk.Frame(pmain, width=1300, height=600, bd=1, bg='#48526b', relief=tk.RIDGE)
        data_pmain.pack(side=tk.BOTTOM, fill=tk.BOTH, ipadx=2)

        data_pmain_left = tk.LabelFrame(data_pmain, width=500, height=600, bd=1, pady=10, bg='white', relief=tk.RIDGE,
                                        font=('calibre', 20, 'bold'), text='Additive Information\n')
        data_pmain_left.pack(side=tk.LEFT, fill=tk.BOTH, ipadx=30)

        pmain_title = tk.LabelFrame(data_pmain, bd=1, width=1000, height=600, padx=5, pady=3, bg='white',
                                    relief=tk.RIDGE,
                                    font=('calibre', 20, 'bold'), text='Additive Details\n')
        pmain_title.pack(side=tk.RIGHT, fill=tk.BOTH, ipadx=10)

        # ======================================= DATA ENTRIES ========================================
        product_label = tk.Label(data_pmain_left, font=('calibre', 8), bg='white', text='Product:')
        name_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Name:')
        date_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Date:')
        concentration_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Concentration:')
        price_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Price:')
        substances_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Substances(CAS):')
        msds_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='MSDS:')
        comment_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Comment:')
        separator_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='\nContained Substances:\n')
        substances_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Substances:')
        contained_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Concentrations:')

        pr_code = tk.Entry(data_pmain_left, width=30, font=('calibre', 8), textvariable=self.pr_code)
        name = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.name)
        date = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.date)
        concentration = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.concentration)
        price = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.price)
        substances = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.substances)
        msds = tk.Button(data_pmain_left, width=30, font=('calibre', 15), text='Choose file', relief=tk.RIDGE,
                         command=Page.open_file, state=tk.DISABLED)
        comment = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.comment)
        substances = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.substances)
        contained = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.contained)

        product_label.grid(row=5, column=0, padx=2, pady=10, sticky=tk.W)
        name_label.grid(row=6, column=0, padx=2, pady=10, sticky=tk.W)
        date_label.grid(row=7, column=0, padx=2, pady=10, sticky=tk.W)
        concentration_label.grid(row=8, column=0, padx=2, pady=10, sticky=tk.W)
        price_label.grid(row=9, column=0, padx=2, pady=10, sticky=tk.W)
        substances_label.grid(row=10, column=0, padx=2, pady=10, sticky=tk.W)
        msds_label.grid(row=11, column=0, padx=2, pady=10, sticky=tk.W)
        comment_label.grid(row=12, column=0, padx=2, pady=10, sticky=tk.W)
        separator_label.grid(row=13, column=0, padx=2, pady=10, sticky=tk.W)
        substances_label.grid(row=14, column=0, padx=2, pady=10, sticky=tk.W)
        contained_label.grid(row=15, column=0, padx=2, pady=10, sticky=tk.W)

        pr_code.grid(row=5, column=1, ipadx=2, ipady=2)
        name.grid(row=6, column=1, ipadx=2, ipady=2)
        date.grid(row=7, column=1, ipadx=2, ipady=2)
        concentration.grid(row=8, column=1, ipadx=2, ipady=2)
        price.grid(row=9, column=1, ipadx=2, ipady=2)
        substances.grid(row=10, column=1, ipadx=2, ipady=2)
        msds.grid(row=11, column=1, ipadx=2, ipady=2)
        comment.grid(row=12, column=1, ipadx=2, ipady=2)
        substances.grid(row=14, column=1, ipadx=2, ipady=2)
        contained.grid(row=15, column=1, ipadx=2, ipady=2)

        # ======================================= SCROLLBARS ========================================

        scrollbar1 = tk.Scrollbar(pmain_title)
        scrollbar1.grid(row=1, column=1, sticky='ns')
        scrollbar2 = tk.Scrollbar(pmain_title)
        scrollbar2.grid(row=3, column=1, sticky='ns')

        label1 = tk.Label(pmain_title, font=('calibre', 12), text='Additives', bg='white')
        label1.grid(row=0, column=0, padx=3)
        additive_list = tk.Listbox(pmain_title, width=105, height=15, font=('calibre', 12),
                                   yscrollcommand=scrollbar1.set)
        additive_list.grid(row=1, column=0, padx=3)
        scrollbar1.config(command=additive_list.yview)

        label1 = tk.Label(pmain_title, font=('calibre', 12), text='Substances', bg='white')
        label1.grid(row=2, column=0, padx=3)
        additive_substance_list = tk.Listbox(pmain_title, width=105, height=15, font=('calibre', 12),
                                             yscrollcommand=scrollbar2.set)
        additive_substance_list.grid(row=3, column=0, padx=3)
        scrollbar2.config(command=additive_substance_list.yview)

        # ======================================= BUTTONS ========================================

        add = tk.Button(button_pmain, text='Add new', font=('calibre', 12), height=1, width=10, bd=2,
                        relief=tk.RIDGE, command=lambda: add_one(self))
        add.grid(row=0, column=0, padx=10)

        done = tk.Button(button_pmain, text='Done', font=('calibre', 8), height=1, width=10, bd=2,
                         relief=tk.RIDGE, command=lambda: add_data(self))
        done.grid(row=0, column=1, padx=10)

        display = tk.Button(button_pmain, text='Display', font=('calibre', 12), height=1, width=10, bd=2,
                            relief=tk.RIDGE, command=lambda:display_data(self))
        display.grid(row=0, column=2, padx=10)

        clear = tk.Button(button_pmain, text='Clear', font=('calibre', 12), height=1, width=10, bd=2,
                          relief=tk.RIDGE,command=lambda:clear_data(self))
        clear.grid(row=0, column=3, padx=10)

        delete = tk.Button(button_pmain, text='Delete', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE, command=lambda:delete_data(self))
        delete.grid(row=0, column=4, padx=10)

        search = tk.Button(button_pmain, text='Search', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE, command=lambda:search_data(self))
        search.grid(row=0, column=5, padx=10)

        update = tk.Button(button_pmain, text='Update', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE,command=lambda:update_data(self))
        update.grid(row=0, column=6, padx=10)

        Exit = tk.Button(button_pmain, text='Exit', font=('calibre', 12), height=1, width=10, bd=2,
                         relief=tk.RIDGE, command=lambda: Page.exit(self))
        Exit.grid(row=0, column=7, padx=10)

    # ======================================= FUNCTIONS ========================================


class Page4(Page):
    def __init__(self, *args, **kwargs):
        Page.__init__(self, *args, **kwargs)

        # ======================================= VARIABLES =====================================

        self.pr_code = tk.StringVar()
        self.pr_date = tk.StringVar()
        self.pr_additive = tk.StringVar()

        # ======================================= FRAMES ========================================

        pmain = tk.Frame(self, bg='#0d4357')
        pmain.pack(side=tk.TOP, pady=10, expand=True)

        title_pmain = tk.Frame(pmain, bd=2, padx=10, pady=8, bg='white', relief=tk.RIDGE)
        title_pmain.pack(side=tk.TOP, fill=tk.X, ipadx=10, pady=10)

        self.title = tk.Label(title_pmain, font=('calibre', 30, 'bold'), text='Classification', bg='white')
        self.title.grid(sticky='we')

        data_pmain = tk.Frame(pmain, width=1300, height=600, bd=1, bg='#48526b', relief=tk.RIDGE)
        data_pmain.pack(side=tk.BOTTOM, fill=tk.BOTH, ipadx=2)

        data_pmain_left = tk.LabelFrame(data_pmain, width=500, height=600, bd=1, pady=10, bg='white', relief=tk.RIDGE,
                                        font=('calibre', 20, 'bold'), text='Product Information\n')
        data_pmain_left.pack(side=tk.LEFT, fill=tk.BOTH, ipadx=30)

        pmain_title = tk.LabelFrame(data_pmain, bd=1, width=1000, height=600, padx=5, pady=3, bg='white',
                                    relief=tk.RIDGE,
                                    font=('calibre', 20, 'bold'), text='Classification Details')
        pmain_title.pack(side=tk.RIGHT, fill=tk.BOTH, ipadx=10)

        # ======================================= DATA ENTRIES ========================================

        code_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Code:')
        name_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Name:')
        grade_label = tk.Label(data_pmain_left, font=('calibre', 15), bg='white', text='Grade:')

        code = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.pr_code)
        name = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.pr_date)
        grade = tk.Entry(data_pmain_left, width=30, font=('calibre', 15), textvariable=self.pr_additive)

        code_label.grid(row=4, column=0, padx=2, pady=10, sticky=tk.W)
        name_label.grid(row=5, column=0, padx=2, pady=10, sticky=tk.W)
        grade_label.grid(row=6, column=0, padx=2, pady=10, sticky=tk.W)

        code.grid(row=4, column=1, ipadx=2, ipady=2)
        name.grid(row=5, column=1, ipadx=2, ipady=2)
        grade.grid(row=6, column=1, ipadx=2, ipady=2)

        # ======================================= SCROLLBARS ========================================

        scrollbar = tk.Scrollbar(pmain_title)
        scrollbar.grid(row=0, column=1, sticky='ns')

        product_list = tk.Listbox(pmain_title, width=105, height=40, font=('calibre', 12), yscrollcommand=scrollbar.set)
        product_list.grid(row=0, column=0, padx=3)
        scrollbar.config(command=product_list.yview)

        scrollbar = tk.Scrollbar(data_pmain_left)
        scrollbar.grid(row=7, column=2, sticky='ns')

        additive_list = tk.Listbox(data_pmain_left, width=37, height=20, font=('calibre', 12),
                                   yscrollcommand=scrollbar.set)
        additive_list.grid(row=7, column=0, columnspan=2, sticky='e')
        scrollbar.config(command=product_list.yview)


class MainView(tk.Frame):
    def __init__(self, *args, **kwargs):
        tk.Frame.__init__(self, *args, **kwargs)

        tk.Frame.__init__(self)

        p1 = Page1(self)
        p2 = Page2(self)
        p3 = Page3(self, title=2)
        p4 = Page4(self)

        buttonframe = tk.Frame(self)
        container = tk.Frame(self)
        buttonframe.pack(side="top", fill="x", expand=False)
        container.pack(side="top", fill="both", expand=True)

        p1.place(in_=container, x=0, y=0, relwidth=1, relheight=1)
        p1.configure(bg='#0d4357')
        p2.place(in_=container, x=0, y=0, relwidth=1, relheight=1)
        p2.configure(bg='#0d4357')
        p3.place(in_=container, x=0, y=0, relwidth=1, relheight=1)
        p3.configure(bg='#0d4357')
        p4.place(in_=container, x=0, y=0, relwidth=1, relheight=1)
        p4.configure(bg='#0d4357')

        b1 = tk.Button(buttonframe, text="Page 1", command=p1.lift)
        b2 = tk.Button(buttonframe, text="Product", command=p2.lift)
        b3 = tk.Button(buttonframe, text="Additive", command=p3.lift)
        b4 = tk.Button(buttonframe, text="Classification", command=p4.lift)

        b1.pack(side="left")
        b2.pack(side="left")
        b3.pack(side="left")
        b4.pack(side="left")

        p1.show()


if __name__ == "__main__":
    root = tk.Tk()
    main = MainView(root)
    main.pack(side="top", fill="both", expand=True)
    root.columnconfigure(0, weight=1)
    root.rowconfigure(1, weight=1)
    root.wm_geometry("1700x900+0+0")
    root.mainloop()
