import tkinter as tk
import tkinter.ttk as ttk
from tkinter import messagebox, CENTER, W
from tkinter import filedialog as fd
from DBInteract import DBInteraction
import classification as cl
from PIL import ImageTk, Image

class Page(tk.Frame):
    def __init__(self, *args, **kwargs):
        tk.Frame.__init__(self, *args, **kwargs)

    def show(self):
        self.lift()

    def open_file(self):
        file_path = fd.askopenfile(mode='r')
        if file_path is not None:
            pass

    def exit(self):
        Exit = messagebox.askyesno('Classification Management', 'Confirm exit')
        if Exit > 0:
            root.destroy()
            return

    def copy_from_treeview(self, tree, event):
        selection = tree.selection()
        root.clipboard_clear()
        column = tree.identify_column(event.x)
        column_no = int(column.replace('#', '')) - 1

        for item in selection:
            try:
                value = tree.item(item)['values'][column_no]
                root.clipboard_append(value)
            except:
                pass


class Page1(Page):
    def __init__(self, *args, **kwargs):
        Page.__init__(self, *args, **kwargs)

        # ======================================= VARIABLES =====================================
        self.date_value = tk.StringVar()
        dbi = DBInteraction()


        # ======================================= FUNCTIONS =====================================

        def clear_msds_box():
            for record in msds_list.get_children():
                msds_list.delete(record)

        def update_on_startup(products):
            clear_msds_box()
            if not products:
                errmessage.configure(text='You are all done!', fg='green')
                return
            counter =0
            for p in products:
                msds_list.insert(parent='', index='end', iid=counter, text='', values=
                (p[0], p[1], p[2], p[3]))
                counter += 1

        def display_past_due():
            counter = 0
            clear_msds_box()
            if len(date.get()) != 0:
                found = dbi.select_past_due(date.get())
                if not found:
                    errmessage.configure(text='Nothing due!', fg='green')
                    return
                for p in found:
                    msds_list.insert(parent='', index='end', iid=counter, text='', values=
                    (p[0], p[1], p[2], p[3]))
                    counter += 1


        # ======================================= MAIN FRAMES =====================================


        pmain = tk.Frame(self, bg='#0d4357')
        pmain.pack(side=tk.TOP, pady=10, expand=True)

        title_pmain = tk.Frame(pmain, bd=2, padx=10, pady=8, bg='white', relief=tk.RIDGE)
        title_pmain.pack(side=tk.TOP, fill=tk.X, ipadx=10, pady=10)

        data_pmain = tk.Frame(pmain, width=1300, height=700, bd=1, bg='#48526b', relief=tk.RIDGE)
        data_pmain.pack(side=tk.BOTTOM, fill=tk.BOTH, ipadx=2)

        data_pmain_left = tk.LabelFrame(data_pmain, width=700, height=600, bd=1, pady=10, bg='white', relief=tk.RIDGE,
                                        font=('calibre', 20, 'bold'), text='Info\n')
        data_pmain_left.pack(side=tk.LEFT, fill=tk.BOTH, ipadx=30)

        pmain_title = tk.LabelFrame(data_pmain, bd=1, width=1000, height=700, padx=5, pady=3, bg='white',
                                    relief=tk.RIDGE, font=('calibre', 20, 'bold'), text='Up to Task')
        pmain_title.pack(side=tk.RIGHT, fill=tk.BOTH, ipadx=10)


        # ======================================= DATA - BUTTONS =====================================

        title = tk.Label(title_pmain, font=('calibre', 30, 'bold'), text='MSDS APP', bg='white')
        title_spacing = tk.Label(title_pmain, font=('calibre', 30, 'bold'), bg='white')
        date_label = tk.Label(title_pmain, font=('calibre', 15, 'bold'), text='Date due:', bg='white')
        date = tk.Entry(title_pmain, font=('calibre', 15), bg='white', textvariable=self.date_value)
        date.insert(tk.END, 'YYYY-MM-DD')
        submit = tk.Button(title_pmain, font=('calibre', 12), height=1, width=10, bd=2, relief=tk.RIDGE,
                                text='Display', command=display_past_due)
        Exit = tk.Button(title_pmain, text='Exit', font=('calibre', 12), height=1, width=10, bd=2, relief=tk.RIDGE,
                         command=lambda: Page.exit(self))

        title.grid(row=0, column=0, sticky='we')
        title_spacing.grid(row=0, column=1, ipadx=100, sticky='we')
        date_label.grid(row=0, ipadx=10, column=2, sticky='e')
        date.grid(row=0, column=3, sticky='e')
        submit.grid(row=0, column=4, padx=10, sticky='e')
        Exit.grid(row=0, column=5, padx=10, sticky='e')


        text = '''An app that helps with the classification of mechanical oils and the msds handling.
(Script for automatic classification on the works, along other things.

Top window bottons navigate the app's pages.\nDates are entered in format:'%Y-%M-%D'.\nAll entries are case sensitive.
In General: Exit Buttons quit the app\nClear Buttons clear entry boxes.\n
In Up to Task are displayed products older than 1 and a half years.Or you can specify the date on Date Due.\nDisplay selects all products or additives in db.
Classification Tab:
Search desplays all additives in the product.
Display gets additives classification, if the additive is given.
Classify displays the products classification.

ALL DATA ABOUT THE CONSISTENCY OF PRODUCTS, ADDITIVES AND SUBSTANCES ARE RANDOM
                  
                  '''

        # ==================================== SCROLLBARS - TREEVIEWS =====================================

        description = tk.Label(data_pmain_left, font=('calibre', 12), text=text, bg='white', wraplength=420,
                               justify=tk.LEFT)
        description.grid(row=0, column=0, padx=20, sticky='wens')

        scrollbar_msds = tk.Scrollbar(pmain_title)
        scrollbar_msds.grid(row=1, column=1, sticky='ns')

        errmessage = tk.Label(pmain_title, font=('calibre', 11), fg='#cf190c', bg='white', justify=tk.RIGHT)
        errmessage.grid(row=2, column=0, padx=3, columnspan=2, pady=2, sticky='ws')

        msds_list = ttk.Treeview(pmain_title, height=28, yscrollcommand=scrollbar_msds.set)
        msds_list['columns'] = ("Product", "MSDS", "Last Updated", 'Document')

        msds_list.column('#0', width=0, stretch=tk.NO)
        msds_list.column("Product", anchor=W, width=220)
        msds_list.column("MSDS", anchor=W, width=220)
        msds_list.column("Last Updated", anchor=W, width=220)
        msds_list.column('Document', anchor=W, width=220)

        msds_list.heading('#0', anchor=W)
        msds_list.heading("Product", text="Product", anchor=W)
        msds_list.heading("MSDS", text="MSDS", anchor=W)
        msds_list.heading("Last Updated", text="Last Updated", anchor=W)
        msds_list.heading('Document', text='Document', anchor=W)
        msds_list.bind('<Control-c>', lambda event: Page.copy_from_treeview(self, msds_list, event))

        msds_list.grid(row=1, column=0, padx=3, pady=3)
        scrollbar_msds.config(command=msds_list.yview)

        update_on_startup(dbi.select_past_due())



class Page2(Page):
    def __init__(self, *args, **kwargs):
        Page.__init__(self, *args, **kwargs)
        dbi = DBInteraction()
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

        def select_msds_file():
            global filename
            filename = fd.askopenfilename(title='Open file', initialdir='/')
            if filename is None or filename == '':
                msds_filename_label.config(text = 'no file chosen')
                return

            msds_filename_label.config(text = filename.split('/')[-1])

        def clear_data():
            code.delete(0, tk.END)
            name.delete(0, tk.END)
            grade.delete(0, tk.END)
            category.delete(0, tk.END)
            viscosity.delete(0, tk.END)
            company.delete(0, tk.END)
            comment.delete(0, tk.END)
            date.delete(0, tk.END)
            errmessage.configure(text='')

        def clear_data_box():
            for record in product_list.get_children():
                product_list.delete(record)

        def clear_msds_box():
            for record in msds_list.get_children():
                msds_list.delete(record)

        def display_data():
            counter = 0
            clear_data_box()
            for p in dbi.view_product():
                product_list.insert(parent='', index='end', iid=counter, text='', values=
                (p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]))
                counter += 1
            if len(code.get())!=0:
                clear_msds_box()
                msds = dbi.select_past_due('2000-1-1', code.get())
                mpcounter =0
                for p in msds:
                    msds_list.insert(parent='', index='end', iid=mpcounter, text='', values=
                    (p[0], p[1], p[2], p[3]))
                    mpcounter += 1

        def add_data():
            global new_pr_date
            new_pr_date = date.get()
            clear_data_box()
            if len(code.get()) != 0:
                companies = dbi.select_all_companies()
                if len(company.get()) != 0 and (company.get() in companies):

                    product = dbi.add_product(name.get(), grade.get(), code.get(),
                                              category.get(), viscosity.get(), company.get(),
                                              filename if filename is not None else '')
                    if product is not None:
                        errmessage.configure(text='')
                        product_list.insert(parent='', index='end', iid=0, text='', values=
                        (product[0], product[1], product[2], product[3], product[4], product[5], product[6], product[7]))
                    else:
                        errmessage.configure(text='*The product already exists')
                else:
                    companies = 'Company must be one of: '
                    for c in dbi.select_all_companies():
                        companies += c + ', '
                    errmessage.configure(text=companies)

        def product_record(event):
            clear_data()
            cur_record = product_list.focus()
            p = product_list.item(cur_record).get('values')
            code.insert(tk.END, p[3])
            name.insert(tk.END, p[1])
            grade.insert(tk.END, p[2])
            category.insert(tk.END, p[4])
            viscosity.insert(tk.END, p[5])
            company.insert(tk.END, p[6])
            comment.insert(tk.END, p[7])

        def delete_data():
            if len(code.get()) != 0:
                Exit = messagebox.askyesno('Product Management', 'Delete?')
                if Exit > 0:
                    dbi.delete_product(code.get())
                clear_data()
                clear_data_box()
                display_data()

        def search_data():
            clear_data_box()
            selected = drop.get()
            results = []
            if selected == 'Search by...':
                return
            elif selected == 'Code':
                results = dbi.search_product(code=code.get())
            elif selected == 'Name':
                results = dbi.search_product(name=name.get())
            elif selected == 'Company':
                results = dbi.search_product(company=company.get())
            elif selected == 'Category':
                results = dbi.search_product(category=category.get())
            elif selected == 'Grade':
                results = dbi.search_product(grade=grade.get())
            counter = 0
            for p in results:
                product_list.insert(parent='', index='end', iid=counter, text='', values=
                (p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]))
                counter += 1

        def update_data():
            cur_record = product_list.focus()
            p = product_list.item(cur_record).get('values')
            if p:
                pr = dbi.update_product(name.get(), grade.get(), code.get(),
                            category.get(), viscosity.get(), company.get(),p[0])
                clear_data_box()
                product_list.insert(parent='', index='end', iid=0, text='', values=
                (pr[0], pr[1], pr[2], pr[3], pr[4], pr[5], pr[6], pr[7]))

        def display_past_due():
            counter = 0
            clear_msds_box()
            errmessage.configure(text='')
            if len(date.get())!= 0 and len(code.get()) !=0:
                found = dbi.select_past_due(date.get(), code.get())
                if not found:
                    errmessage.configure(text='Nothing due!', fg='green')
                    return
                for p in found:
                    msds_list.insert(parent='', index='end', iid=counter, text='', values=
                    (p[0], p[1], p[2], p[3].split('/')[-1]))
                    counter += 1
            else:
                found = dbi.select_past_due(date.get())
                if not found:
                    errmessage.configure(text='Nothing due!', fg='green')
                    return
                for p in found:
                    msds_list.insert(parent='', index='end', iid=counter, text='', values=
                    (p[0], p[1], p[2], p[3].split('/')[-1]))
                    counter += 1
        # ======================================= FRAMES ========================================

        pmain = tk.Frame(self, bg='#0d4357')
        pmain.pack(side=tk.TOP, pady=10, expand=True)

        title_pmain = tk.Frame(pmain, bd=2, padx=10, pady=8, bg='white', relief=tk.RIDGE)
        title_pmain.pack(side=tk.TOP, fill=tk.X, ipadx=10, pady=10)

        self.title = tk.Label(title_pmain, font=('calibre', 30, 'bold'), text='Products Management', bg='white')
        self.title.grid(sticky='we')

        button_pmain = tk.Frame(pmain, width=1750, height=70, bd=2, padx=18, pady=10, bg='white', relief=tk.RIDGE)
        button_pmain.pack(side=tk.BOTTOM, pady=10, fill=tk.X)

        data_pmain = tk.Frame(pmain, width=1300, height=700, bd=1, bg='#48526b', relief=tk.RIDGE)
        data_pmain.pack(side=tk.BOTTOM, fill=tk.BOTH, ipadx=2)

        data_pmain_left = tk.LabelFrame(data_pmain, width=500, height=700, bd=1, pady=3, bg='white', relief=tk.RIDGE,
                                        font=('calibre', 20, 'bold'), text='Product Information\n')
        data_pmain_left.pack(side=tk.LEFT, fill=tk.BOTH, ipadx=30)

        pmain_title = tk.LabelFrame(data_pmain, bd=1, width=1000, height=700, padx=5, pady=3, bg='white',
                                    relief=tk.RIDGE,
                                    font=('calibre', 20, 'bold'), text='Product Details\n')
        pmain_title.pack(side=tk.RIGHT, fill=tk.BOTH, ipadx=10)

        # ======================================= DATA ENTRIES  ========================================

        code_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Code:')
        name_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Name:')
        grade_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Grade:')
        category_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Category:')
        viscosity_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Viscosity:')
        company_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Company:')
        comment_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Comment:')
        separator_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='\nData Sheet Information\n')
        msds_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='MSDS:')
        msds_filename_label = tk.Label(data_pmain_left, font=('calibre', 13), width=18, bg='white',  text='sample.pdf')
        date_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Last Updated:')


        code = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.pr_code)
        name = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.pr_name)
        grade = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.pr_grade)
        category = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.pr_category)
        viscosity = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.pr_viscosity)
        company = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.pr_company)
        comment = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.pr_comment)
        msds = tk.Button(data_pmain_left, width=12, font=('calibre', 13), text='Choose file',
                         relief=tk.RIDGE, command=select_msds_file)
        date = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.date)
        date.insert(tk.END, 'YYYY-MM-DD')

        code_label.grid(row=4, column=0, padx=2, pady=10, sticky=tk.W)
        name_label.grid(row=5, column=0, padx=2, pady=10, sticky=tk.W)
        grade_label.grid(row=6, column=0, padx=2, pady=10, sticky=tk.W)
        category_label.grid(row=7, column=0, padx=2, pady=10, sticky=tk.W)
        viscosity_label.grid(row=8, column=0, padx=2, pady=10, sticky=tk.W)
        company_label.grid(row=9, column=0, padx=2, pady=10, sticky=tk.W)
        comment_label.grid(row=10, column=0, padx=2, pady=10, sticky=tk.W)
        separator_label.grid(row=11, column=0, padx=2, pady=10, columnspan=2, sticky=tk.W)
        msds_label.grid(row=12, column=0, padx=2, pady=10, sticky=tk.W)
        msds_filename_label.grid(row=12, column=1, padx=2, pady=10, sticky=tk.W)
        date_label.grid(row=13, column=0, padx=2, pady=10, sticky=tk.W)

        code.grid(row=4, column=1, ipadx=2, ipady=2, columnspan=2)
        name.grid(row=5, column=1, ipadx=2, ipady=2, columnspan=2)
        grade.grid(row=6, column=1, ipadx=2, ipady=2, columnspan=2)
        category.grid(row=7, column=1, ipadx=2, ipady=2, columnspan=2)
        viscosity.grid(row=8, column=1, ipadx=2, ipady=2, columnspan=2)
        company.grid(row=9, column=1, ipadx=2, ipady=2, columnspan=2)
        comment.grid(row=10, column=1, ipadx=2, ipady=2, columnspan=2)
        msds.grid(row=12, column=2, ipadx=2, ipady=2)
        date.grid(row=13, column=1, ipadx=2, ipady=2, columnspan=2)

        # ======================================= SCROLLBARS - TREEVIEWS ========================================

        errmessage = tk.Label(pmain_title, font=('calibre', 10), fg='#cf190c', bg='white', justify=tk.RIGHT)
        errmessage.grid(row=2, column=0, padx=3, columnspan=2, pady=2, sticky='ws')

        scrollbar = tk.Scrollbar(pmain_title)
        scrollbar.grid(row=0, column=1, sticky='ns')
        scrollbar_msds = tk.Scrollbar(pmain_title)
        scrollbar_msds.grid(row=1,column=1,sticky='ns')

        product_list = ttk.Treeview(pmain_title, height=15, yscrollcommand=scrollbar.set)
        product_list['columns']=("ID", "Name", "Grade", "Code", "Category", "Viscosity", "Company", "Comment")
        # Column Format
        product_list.column('#0', width=0, stretch=tk.NO)
        product_list.column('ID', anchor=CENTER, width=80)
        product_list.column('Name', anchor=W, width=120)
        product_list.column('Grade', anchor=W, width=120)
        product_list.column('Code', anchor=W, width=120)
        product_list.column('Category', anchor=W, width=120)
        product_list.column('Viscosity', anchor=W, width=120)
        product_list.column('Company', anchor=W, width=120)
        product_list.column('Comment', anchor=W, width=120)

        # Create Headings
        product_list.heading('#0', anchor=W)
        product_list.heading('ID', text='ID', anchor=CENTER)
        product_list.heading('Name', text='Name', anchor=W)
        product_list.heading('Grade', text='Grade', anchor=W)
        product_list.heading('Code', text='Code', anchor=W)
        product_list.heading('Category', text='Category', anchor=W)
        product_list.heading('Viscosity', text='Viscosity', anchor=W)
        product_list.heading('Company', text='Company', anchor=W)
        product_list.heading('Comment', text='Comment', anchor=W)
        product_list.bind('<ButtonRelease-1>', product_record)
        product_list.bind('<Control-c>', lambda event: Page.copy_from_treeview(self, product_list, event))

        product_list.grid(row=0, column=0, padx=3)
        scrollbar.config(command=product_list.yview)

        msds_list = ttk.Treeview(pmain_title, height=8, yscrollcommand=scrollbar_msds.set)
        msds_list['columns'] = ("Product", "MSDS", "Last Updated", 'Document')

        # Column Format
        msds_list.column('#0', width=0, stretch=tk.NO)
        msds_list.column("Product", anchor=W, width=230)
        msds_list.column("MSDS", anchor=W, width=230)
        msds_list.column("Last Updated", anchor=W, width=230)
        msds_list.column('Document', anchor=W, width=230)

        # Create Headings
        msds_list.heading('#0', anchor=W)
        msds_list.heading("Product", text="Product", anchor=W)
        msds_list.heading("MSDS", text="MSDS", anchor=W)
        msds_list.heading("Last Updated", text="Last Updated", anchor=W)
        msds_list.heading('Document', text='Document', anchor=W)
        msds_list.bind('<Control-c>', lambda event: Page.copy_from_treeview(self, msds_list, event))

        msds_list.grid(row=1, column=0, padx=3, pady=3)
        scrollbar_msds.config(command=msds_list.yview)


        # ======================================= BUTTONS ========================================

        display = tk.Button(button_pmain, text='Display All', font=('calibre', 12), height=1, width=10, bd=2,
                          relief=tk.RIDGE, command=display_data)
        display.grid(row=0, column=0, padx=10)

        add = tk.Button(button_pmain, text='Add new', font=('calibre', 12), height=1, width=10, bd=2,
                        relief=tk.RIDGE, command=add_data)
        add.grid(row=0, column=1, padx=10)

        update = tk.Button(button_pmain, text='Update', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE, command=update_data)
        update.grid(row=0, column=2, padx=10)

        delete = tk.Button(button_pmain, text='Delete', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE, command=delete_data)
        delete.grid(row=0, column=3, padx=10)

        drop = ttk.Combobox(button_pmain, font=('calibre', 12), value=['Search by...', 'Code', 'Name', 'Company', 'Grade', 'Category'])
        drop.current(0)
        drop.configure(width=10)
        drop.grid(row=0, ipady=3, column=4, padx=10)

        search = tk.Button(button_pmain, text='Search', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE, command=search_data)
        search.grid(row=0, column=5, padx=10)

        display_ps = tk.Button(button_pmain, text='Past Due', font=('calibre', 12), height=1, width=10, bd=2,
                            relief=tk.RIDGE, command=display_past_due)
        display_ps.grid(row=0, column=6, padx=10)

        clear = tk.Button(button_pmain, text='Clear Fields', font=('calibre', 12), height=1, width=10, bd=2,
                          relief=tk.RIDGE, command=clear_data)
        clear.grid(row=0, column=7, padx=10)

        Exit = tk.Button(button_pmain, text='Exit', font=('calibre', 12), height=1, width=10, bd=2,
                         relief=tk.RIDGE, command=lambda:Page.exit(self))
        Exit.grid(row=0, column=8, padx=10)


class Page3(Page):
    def __init__(self, *args, **kwargs):
        checked = kwargs.pop('title')
        Page.__init__(self, *args, **kwargs)
        dbi = DBInteraction()
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
        self.pr_code = tk.StringVar()  # product useful only when adding an additive to a product.

        # ======================================= FUNCTIONS ========================================

        def clear_data():
            name.delete(0, tk.END)
            date.delete(0, tk.END)
            concentration.delete(0, tk.END)
            price.delete(0, tk.END)
            substances.delete(0, tk.END)
            comment.delete(0, tk.END)
            contained.delete(0, tk.END)
            errmessage.configure(text='')

        def clear_additives_box():
            for record in additive_list.get_children():
                additive_list.delete(record)

        def clear_substances_box():
            for record in additive_substance_list.get_children():
                additive_substance_list.delete(record)

        def add_one():
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
            clear_data()
            errmessage.configure(text=dict_adds.get(n), fg="Green")


        def add_data():
            # 332491-18-3,536722-82-0   12.4, 45.6  712393-16-0    25.6
            all_additives = set()
            all_substances = set()
            additive = list()
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
            a_added = dbi.add_additive(list(all_additives))
            if a_added:
                message = tk.Label(self, text=a_added)
                message.pack()
                root.after(2000, message.destroy)

            # add additive substances
            s_added = dbi.add_additive_substances(tuple(all_substances))
            if s_added:
                message = tk.Label(self, text=s_added)
                message.pack()
                root.after(2000, message.destroy)

            # add product additives
            additive_names = tuple(dict_adds.keys())
            if len(pr_code.get())!=0:
                pa_added = dbi.add_product_additives(pr_code.get(), additive_names, tuple(concentrations))
                if pa_added:
                    message = tk.Label(self, text=pa_added)
                    message.pack()
                    root.after(2000, message.destroy)
            dict_adds.clear()

        def display_all_additives():
            clear_additives_box()
            countera = 0
            for p in dbi.view_additive():
                additive_list.insert(parent='', index='end', iid=countera, text='', values=
                (p[0], p[1], p[2], p[3], p[4], p[5]))
                countera += 1

        def display_additive_substances():
            clear_substances_box()
            if len(name.get()) != 0:
                counters=0
                subs = dbi.select_additive_classification(name.get())
                for s in subs:
                    additive_substance_list.insert(parent='', index='end', iid=counters, text='',
                                                   values= (s[0], s[1], s[2], s[3]))
                    counters += 1

        def additive_record(event):
            clear_data()
            cur_record = additive_list.focus()
            a = additive_list.item(cur_record).get('values')
            name.insert(tk.END, a[1])
            date.insert(tk.END, a[2])
            price.insert(tk.END, a[3])
            concentration.insert(tk.END, 0.0)
            comment.insert(tk.END, a[5])

        def additive_substance_record(event):
            s = set()
            c = set()
            for line in additive_substance_list.get_children():
                sub = additive_substance_list.item(line).get('values')
                s.add(sub[0])
                c.add(sub[1])
            substances.insert(tk.END, ','.join(list(s)))
            contained.insert(tk.END, ','.join(list(c)))

        def delete_data():
            Exit = messagebox.askyesno('Additive Management', 'Delete?')
            if Exit > 0:
                dbi.delete_additive(name.get())
            clear_data()
            clear_additives_box()
            display_all_additives()

        def search_data():
            clear_additives_box()
            counter = 0
            for a in dbi.search_additive(name.get(), date.get(), price.get(), comment.get()):
                additive_list.insert(parent='', index='end', iid=counter, text='', values=
                (a[0], a[1], a[2], a[3], a[4], a[5]))
                counter += 1

        def update_data():
            cur_record = additive_list.focus()
            a = additive_list.item(cur_record).get('values')
            if a:
                add = dbi.update_additive(date.get(), price.get(), comment.get(), name.get())
                errmessage.configure(text=add, fg='green')
                display_all_additives

        # ======================================= FRAMES ========================================

        pmain = tk.Frame(self, bg='#0d4357')
        pmain.pack(side=tk.TOP, pady=10, expand=True)

        title_pmain = tk.Frame(pmain, bd=2, padx=10, pady=8, bg='white', relief=tk.RIDGE)
        title_pmain.pack(side=tk.TOP, fill=tk.X, ipadx=10, pady=10)

        self.title = tk.Label(title_pmain, font=('calibre', 30, 'bold'), text='Additive Management', bg='white')
        self.title.grid(sticky='we')

        button_pmain = tk.Frame(pmain, width=1750, height=70, bd=2, padx=18, pady=10, bg='white', relief=tk.RIDGE)
        button_pmain.pack(side=tk.BOTTOM, pady=10, fill=tk.X)

        data_pmain = tk.Frame(pmain, width=1300, height=700, bd=1, bg='#48526b', relief=tk.RIDGE)
        data_pmain.pack(side=tk.BOTTOM, fill=tk.BOTH, ipadx=2)

        data_pmain_left = tk.LabelFrame(data_pmain, width=500, height=700, bd=1, pady=3, bg='white', relief=tk.RIDGE,
                                        font=('calibre', 20, 'bold'), text='Additive Information\n')
        data_pmain_left.pack(side=tk.LEFT, fill=tk.BOTH, ipadx=30)

        pmain_title = tk.LabelFrame(data_pmain, bd=1, width=1000, height=700, padx=5, pady=3, bg='white',
                                    relief=tk.RIDGE,
                                    font=('calibre', 20, 'bold'), text='Additive Details\n')
        pmain_title.pack(side=tk.RIGHT, fill=tk.BOTH, ipadx=10)


        # ======================================= DATA ENTRIES ========================================


        product_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Product:')
        name_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Name:')
        date_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Date:')
        concentration_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Concentration:')
        price_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Price:')
        substances_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Substances(CAS):')
        msds_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='MSDS:')
        comment_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Comment:')
        separator_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='\nContained Substances:\n')
        substances_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Substances:')
        contained_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Concentrations:')

        pr_code = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.pr_code)
        name = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.name)
        date = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.date)
        date.insert(tk.END, 'YYYY-MM-DD')
        concentration = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.concentration)
        price = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.price)
        substances = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.substances)
        msds = tk.Button(data_pmain_left, width=30, font=('calibre', 13), text='Choose file', relief=tk.RIDGE,
                         command=Page.open_file, state=tk.DISABLED)
        comment = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.comment)
        substances = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.substances)
        contained = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.contained)

        product_label.grid(row=5, column=0, padx=2, pady=10, sticky=tk.W)
        name_label.grid(row=6, column=0, padx=2, pady=10, sticky=tk.W)
        date_label.grid(row=7, column=0, padx=2, pady=10, sticky=tk.W)
        concentration_label.grid(row=8, column=0, padx=2, pady=10, sticky=tk.W)
        price_label.grid(row=9, column=0, padx=2, pady=10, sticky=tk.W)
        substances_label.grid(row=10, column=0, padx=2, pady=10, sticky=tk.W)
        msds_label.grid(row=11, column=0, padx=2, pady=10, sticky=tk.W)
        comment_label.grid(row=12, column=0, padx=2, pady=10, sticky=tk.W)
        separator_label.grid(row=13, column=0, padx=2, pady=10,columnspan=2, sticky=tk.W)
        substances_label.grid(row=14, column=0, padx=2, pady=10, sticky=tk.W)
        contained_label.grid(row=15, column=0, padx=2, pady=10, sticky=tk.W)

        pr_code.grid(row=5, column=1, ipady=2)
        name.grid(row=6, column=1,  ipady=2)
        date.grid(row=7, column=1, ipady=2)
        concentration.grid(row=8,column=1, ipady=2)
        price.grid(row=9, column=1,  ipady=2)
        substances.grid(row=10, column=1, ipady=2)
        msds.grid(row=11, column=1,  ipady=2)
        comment.grid(row=12, column=1, ipady=2)
        substances.grid(row=14, column=1, ipady=2)
        contained.grid(row=15, column=1, ipady=2)


        # ======================================= SCROLLBARS - TREEVIEWS ========================================
        scrollbar1 = tk.Scrollbar(pmain_title)
        scrollbar1.grid(row=0, column=1, sticky='ns')
        scrollbar2 = tk.Scrollbar(pmain_title)
        scrollbar2.grid(row=1, column=1, sticky='ns')

        errmessage = tk.Label(pmain_title, font=('calibre', 10), fg='#cf190c', bg='white', justify=tk.RIGHT)
        errmessage.grid(row=2, column=0, padx=3, columnspan=2, pady=2, sticky='ws')

        additive_list = ttk.Treeview(pmain_title, height=15, yscrollcommand=scrollbar1.set)
        additive_list['columns'] = ("ID", "Name", "Last Updated", "Price", "Msds", "Comment")
        # Column Format
        additive_list.column('#0', width=0, stretch=tk.NO)
        additive_list.heading('#0', anchor=W)
        for i in additive_list['columns']:
            additive_list.column(i, anchor=W, width=140)
            additive_list.heading(i, text=i, anchor=W)
        additive_list.grid(row=0, column=0, padx=3)
        additive_list.bind('<ButtonRelease-1>', additive_record)
        additive_list.bind('<Control-c>', lambda event: Page.copy_from_treeview(self, additive_list, event))

        scrollbar1.config(command=additive_list.yview)


        additive_substance_list = ttk.Treeview(pmain_title, height=8, yscrollcommand=scrollbar2.set)
        additive_substance_list['columns'] = ('CAS', 'Concentration', 'SCL','GHS')
        additive_substance_list.column('#0', width=0, stretch=tk.NO)
        additive_substance_list.heading('#0', anchor=W)
        for i in additive_substance_list['columns']:
            additive_substance_list.column(i, anchor=W, width=210)
            additive_substance_list.heading(i, text=i, anchor=W)
        additive_substance_list.grid(row=1, column=0, padx=3, pady=3)
        additive_substance_list.bind('<ButtonRelease-1>', additive_substance_record)
        additive_substance_list.bind('<Control-c>', lambda event: Page.copy_from_treeview(self, additive_substance_list, event))

        scrollbar1.config(command=additive_substance_list.yview)

        # ======================================= BUTTONS ========================================

        display_additives = tk.Button(button_pmain, text='Display All', font=('calibre', 12), height=1, width=10, bd=2,
                            relief=tk.RIDGE, command=display_all_additives)
        display_additives.grid(row=0, column=0, padx=10)

        display_additive_substances = tk.Button(button_pmain, text='Substances', font=('calibre', 12), height=1, width=12, bd=2,
                            relief=tk.RIDGE, command=display_additive_substances)
        display_additive_substances.grid(row=0, column=1, padx=10)

        add = tk.Button(button_pmain, text='Add new', font=('calibre', 12), height=1, width=10, bd=2,
                        relief=tk.RIDGE, command=add_one)
        add.grid(row=0, column=2, padx=10)

        done = tk.Button(button_pmain, text='Done', font=('calibre', 12), height=1, width=10, bd=2,
                         relief=tk.RIDGE, command=add_data)
        done.grid(row=0, column=3, padx=10)

        update = tk.Button(button_pmain, text='Update', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE, command=update_data)
        update.grid(row=0, column=4, padx=10)

        delete = tk.Button(button_pmain, text='Delete', font=('calibre', 12), height=1, width=10, bd=2,
                           relief=tk.RIDGE, command=delete_data)
        delete.grid(row=0, column=5, padx=10)

        search = tk.Button(button_pmain, text='Search By Product', font=('calibre', 12), height=1, width=18, bd=2,
                           relief=tk.RIDGE, command=search_data)
        search.grid(row=0, column=6, padx=10)

        clear = tk.Button(button_pmain, text='Clear', font=('calibre', 12), height=1, width=10, bd=2,
                          relief=tk.RIDGE, command=clear_data)
        clear.grid(row=0, column=7, padx=10)

        Exit = tk.Button(button_pmain, text='Exit', font=('calibre', 12), height=1, width=10, bd=2,
                         relief=tk.RIDGE, command=lambda: Page.exit(self))
        Exit.grid(row=0, column=8, padx=10)
# AB-BB-C-33

class Page4(Page):
    def __init__(self, *args, **kwargs):
        Page.__init__(self, *args, **kwargs)
        dbi = DBInteraction()

        # ======================================= VARIABLES =====================================

        self.pr_code = tk.StringVar()
        self.pr_additive = tk.StringVar()
        self.ad_substance = tk.StringVar()

        # ======================================= FUNCTIONS =====================================

        def clear_box(widget):
            for record in widget.get_children():
                widget.delete(record)

        def clear_data(self):
            code.delete(0, tk.END)
            additive.delete(0,tk.END)
            substance.delete(0, tk.END)
            clear_box(substance_list)
            clear_box(substance_class_list)

        def additive_record(event):
            substance.delete(0, tk.END)
            search_additive = additive_list.curselection()[0]
            add = additive_list.get(search_additive)
            additive.delete(0, tk.END)
            additive.insert(tk.END, add[0])

        def substance_record(event):
            cur_record = substance_list.focus()
            a = substance_list.item(cur_record).get('values')
            substance.delete(0,tk.END)
            substance.insert(tk.END, a[0])

        def display_additives(self):
            additive_list.delete(0, tk.END)
            if len(code.get()) != 0:
                adds = dbi.find_additives(code.get())
                for a in adds:
                    additive_list.insert(tk.END, a)

        def display_additive_classification(self):
            clear_box(substance_list)
            additives = dbi.select_additive_classification(additive.get())
            subs = set([(a[0], a[1]) for a in additives])
            if len(additive.get()) != 0:
                counter = 0
                for s in tuple(subs):
                    substance_list.insert(parent='', index='end', iid=counter, text='', values=
                    (s[0], s[1]))
                    counter += 1

        def display_substance_classification(self):
            clear_box(substance_class_list)
            additives = dbi.select_additive_classification(additive.get())
            if len(substance.get()) != 0:
                classif = [(s[2], s[3]) for s in additives if s[0] == substance.get()]
                clear_box(substance_class_list)
                counter = 0
                for c in classif:
                    substance_class_list.insert(parent='', index='end', iid=counter, text='', values=
                    (c[0], c[1]))
                    counter += 1

        def product_classification(self):
            clear_box(product_list)
            counters = 0
            if len(code.get()) != 0:
                subs = dbi.select_classification(code.get())
                for s in subs:
                    product_list.insert(parent='', index='end', iid=counters, text='',
                                                   values=(s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7]))
                    counters += 1

        def open():
            ''' creates the classification window '''

            top = tk.Toplevel(bg='#0d4357')
            top.geometry('600x800')
            top.title('Product Classification')

            # main frames
            pmain = tk.Frame(top, bg='#0d4357')
            pmain.pack(side=tk.TOP, pady=20, padx=20)
            title = tk.Label(pmain, font=('calibre', 12, 'bold'), width=51, height=2, bg='white', text='Product Classified As')
            title.grid(row=0, column=0, pady=10, columnspan=3, sticky=tk.W)
            part_two = tk.LabelFrame(pmain, width=41, height=10, bd=1, bg='white', relief=tk.RIDGE,
                                     font=('calibre', 12, 'bold'), text='Part 2: Labeling\n')
            part_two.grid(row=1, column=0, columnspan=3, pady=10, sticky='ns')
            part_three = tk.LabelFrame(pmain, width=41, height=10, bd=1, bg='white', relief=tk.RIDGE,
                                       font=('calibre', 12, 'bold'), text='Part 3: Included Substances\n')
            part_three.grid(row=2, column=0, columnspan=3, pady=10, sticky='ns')

            # part 2: classification
            scrollbar = tk.Scrollbar(part_two)
            classification = tk.Listbox(part_two, width=55, height=7, font=('calibre', 12), bg='white',
                                        yscrollcommand=scrollbar.set)
            classification.grid(row=0, column=0, columnspan=2, sticky='e')
            scrollbar.grid(row=0, column=2, sticky='ns')
            scrollbar.config(command=classification.yview)

            # holds pictograms
            canvas = tk.Canvas(part_two, width=496, heigh=50, bg='white')
            canvas.grid(row=1, column=0, columnspan=3, sticky='w')

            # part 3: substances
            scrollbar2 = tk.Scrollbar(part_three)
            involved_subs = tk.Listbox(part_three, width=55, height=10, font=('calibre', 12),
                                        yscrollcommand=scrollbar2.set)
            involved_subs.grid(row=3, column=0, columnspan=2, sticky='e')
            scrollbar2.grid(row=3, column=2, sticky='ns')
            scrollbar2.config(command=involved_subs.yview)

            scrollbar3 = tk.Scrollbar(part_two)
            pcodes = tk.Listbox(part_two, width=55, height=10, font=('calibre', 12),
                                       yscrollcommand=scrollbar3.set)
            pcodes.grid(row=2, column=0, pady=10, columnspan= 2, sticky='e')
            scrollbar3.grid(row=2, column=2, sticky='ns')
            scrollbar3.config(command=pcodes.yview)

            global images
            # load data from db
            if len(code.get()) != 0:
                s, c, pics = cl.classify(dbi.filter_classification(prcode=code.get()))
                s = set(s)
                pcodes_list = set()
                for i in c:
                    classification.insert(tk.END, i)
                    for p in dbi.find_pcodes(i[0]):
                        pcodes_list.add(p)
                for j in enumerate(s):
                    involved_subs.insert(tk.END, j)
                for p in list(pcodes_list):
                    pcodes.insert(tk.END,p)
                images = list()
                for p in pics:
                    img = Image.open('GHS_Pics/'+p+'.jpg')
                    img = img.resize((40, 40))
                    img = ImageTk.PhotoImage(img)
                    images.append(img)

            # place images
            counter = 1
            for i in images:
                canvas.create_image(42*counter, 20 +5, anchor='w', image=i)
                counter +=1

        # ======================================= FRAMES ========================================

        pmain = tk.Frame(self, bg='#0d4357')
        pmain.pack(side=tk.TOP, pady=10, expand=True)

        title_pmain = tk.Frame(pmain, bd=2, padx=10, pady=8, bg='white', relief=tk.RIDGE)
        title_pmain.pack(side=tk.TOP, fill=tk.X, ipadx=10, pady=10)

        self.title = tk.Label(title_pmain, font=('calibre', 30, 'bold'), text='Classification', bg='white')
        self.title.grid(sticky='we')

        button_pmain = tk.Frame(pmain, width=1750, height=70, bd=2, padx=18, pady=10, bg='white', relief=tk.RIDGE)
        button_pmain.pack(side=tk.BOTTOM, pady=10, fill=tk.X)

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

        code_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Code:')
        additive_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Additive:')
        substance_label = tk.Label(data_pmain_left, font=('calibre', 13), bg='white', text='Substance:')
        seperator = tk.Label(data_pmain_left, font=('calibre', 13), bg='white' )
        code = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.pr_code)
        additive = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.pr_additive)
        substance = tk.Entry(data_pmain_left, width=30, font=('calibre', 13), textvariable=self.ad_substance)

        code_label.grid(row=4, column=0, padx=2, pady=10, sticky=tk.W)
        additive_label.grid(row=5, column=0, padx=2, pady=10, sticky=tk.W)
        substance_label.grid(row=6, column=0, padx=2, pady=10, sticky=tk.W)
        seperator.grid(row=7, column=0, padx=2, pady=10, sticky=tk.W)

        code.grid(row=4, column=1, ipadx=2, ipady=2)
        additive.grid(row=5, column=1, ipadx=2, ipady=2)
        substance.grid(row=6, column=1, ipadx=2, ipady=2)


        # ======================================= SCROLLBARS - TREEVIEWS ========================================

        scrollbar1 = tk.Scrollbar(data_pmain_left)
        additive_list = tk.Listbox(data_pmain_left, width=38, height=15, font=('calibre', 12),
                                   yscrollcommand=scrollbar1.set)
        additive_list.grid(row=8, column=0, columnspan=3, sticky='e')
        additive_list.bind('<<ListboxSelect>>', additive_record)
        scrollbar1.grid(row=8, column=3, sticky='ns')
        scrollbar1.config(command=additive_list.yview)

        ##########
        scrollbar2 = tk.Scrollbar(pmain_title)
        substance_list = ttk.Treeview(pmain_title, height=13, yscrollcommand=scrollbar2.set)
        substance_list['columns'] = ("CAS", "Concentration")
        # Column Format
        substance_list.column('#0', width=0, stretch=tk.NO)
        substance_list.heading('#0', anchor=W)
        for i in substance_list['columns']:
            substance_list.column(i, anchor=W, width=220)
            substance_list.heading(i, text=i, anchor=W)
        substance_list.grid(row=0, column=0, padx=3)
        substance_list.bind('<ButtonRelease-1>', substance_record)
        substance_list.bind('<Control-c>', lambda event: Page.copy_from_treeview(self, substance_list, event))

        scrollbar2.config(command=substance_list.yview)
        scrollbar2.grid(row=0, column=1, sticky='ns')

        scrollbar3 = tk.Scrollbar(pmain_title)
        substance_class_list = ttk.Treeview(pmain_title, height=13, yscrollcommand=scrollbar2.set)
        substance_class_list['columns'] = ("SCL", "GHS")
        substance_class_list.column('#0', width=0, stretch=tk.NO)
        substance_class_list.heading('#0', anchor=W)
        for i in substance_class_list['columns']:
            substance_class_list.column(i, anchor=W, width=220)
            substance_class_list.heading(i, text=i, anchor=W)
        substance_class_list.grid(row=0, column=2, padx=3)
        substance_class_list.bind('<ButtonRelease-1>', substance_record)
        substance_class_list.bind('<Control-c>', lambda event: Page.copy_from_treeview(self, substance_class_list, event))

        scrollbar3.config(command=substance_class_list.yview)
        scrollbar3.grid(row=0, column=3, sticky='ns')

        scrollbar = tk.Scrollbar(pmain_title)
        product_list = ttk.Treeview(pmain_title, height=12, yscrollcommand=scrollbar.set)
        product_list['columns'] = ('ADDITIVE', 'ADD %', 'SUBSTANCE', 'SUB %', 'GHS', 'SCL', 'Class', 'Category')
        product_list.column('#0', width=0, stretch=tk.NO)
        product_list.heading('#0', anchor=W)

        product_list.column('ADDITIVE', anchor=W, width=120)
        product_list.heading('ADDITIVE', text='ADDITIVE', anchor=W)
        product_list.column('ADD %', anchor=W, width=90)
        product_list.heading('ADD %', text='ADD %', anchor=W)
        product_list.column('SUBSTANCE', anchor=W, width=120)
        product_list.heading('SUBSTANCE', text='SUBSTANCE', anchor=W)
        product_list.column('SUB %', anchor=W, width=80)
        product_list.heading('SUB %', text='SUB %', anchor=W)
        product_list.column('GHS', anchor=W, width=80)
        product_list.heading('GHS', text='GHS', anchor=W)
        product_list.column('SCL', anchor=W, width=90)
        product_list.heading('SCL', text='SCL', anchor=W)
        product_list.column('Class', anchor=W, width=220)
        product_list.heading('Class', text='Class', anchor=W)
        product_list.column('Category', anchor=W, width=100)
        product_list.heading('Category', text='Category', anchor=W)

        product_list.grid(row=1, column=0, columnspan=3, padx=3, pady=3)
        product_list.bind('<Control-c>', lambda event: Page.copy_from_treeview(self, product_list, event))

        scrollbar.grid(row=1, column=3, sticky='ns')
        scrollbar.config(command=product_list.yview)

        # ======================================= BUTTONS ========================================

        add = tk.Button(button_pmain, text='Search Product Additives', font=('calibre', 12), height=1, width=22, bd=2,
                        relief=tk.RIDGE, command=lambda: display_additives(self))
        add.grid(row=0, column=0, padx=10)

        display_additive_substances = tk.Button(button_pmain, text='Display Substances', font=('calibre', 12), height=1, width=20, bd=2,
                         relief=tk.RIDGE, command=lambda: display_additive_classification(self))
        display_additive_substances.grid(row=0, column=1, padx=10)

        display_substance_class = tk.Button(button_pmain, text='Substance Classification', font=('calibre', 12), height=1, width=22, bd=2,
                         relief=tk.RIDGE, command=lambda: display_substance_classification(self))
        display_substance_class.grid(row=0, column=2, padx=10)

        product_classification_details = tk.Button(button_pmain, text='Classification Details', font=('calibre', 12), height=1, width=20, bd=2,
                           relief=tk.RIDGE, command=lambda:product_classification(self))
        product_classification_details.grid(row=0, column=3, padx=10)

        clear = tk.Button(button_pmain, text='Clear', font=('calibre', 12), height=1, width=10, bd=2,
                          relief=tk.RIDGE,command=lambda:clear_data(self))
        clear.grid(row=0, column=4, padx=10)

        Exit = tk.Button(button_pmain, text='Exit', font=('calibre', 12), height=1, width=10, bd=2,
                         relief=tk.RIDGE, command=lambda: Page.exit(self))
        Exit.grid(row=0, column=5, padx=10)

        separator_label = tk.Label(button_pmain, font=('calibre', 12), bg='white', text='                    ')

        separator_label.grid(row=0, column=5, padx=2, pady=10,columnspan=2, sticky=tk.E)

        classify = tk.Button(button_pmain, text='Classify', font=('calibre', 12), height=1, width=10, bd=2,
                          relief=tk.RIDGE, command=open)
        classify.grid(row=0, column=6, padx=10)


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
        p1.place(in_=container, relx=0, rely=0, relwidth=1, relheight=1)
        p1.configure(bg='#0d4357')
        p2.place(in_=container, relx=0, rely=0, relwidth=1, relheight=1)
        p2.configure(bg='#0d4357')
        p3.place(in_=container, relx=0, rely=0, relwidth=1, relheight=1)
        p3.configure(bg='#0d4357')
        p4.place(in_=container, relx=0, rely=0, relwidth=1, relheight=1)
        p4.configure(bg='#0d4357')

        b1 = tk.Button(buttonframe, text="Main", command=p1.lift)
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
    root.resizable(True, True)

    root.mainloop()
