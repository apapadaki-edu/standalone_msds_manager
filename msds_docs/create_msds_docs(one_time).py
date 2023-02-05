from docx import Document

for i in range(100):
    document = Document()
    document.add_heading(f'msds_{i+1}')
    document.save(f'msd{i+1}.docx')
