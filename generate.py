# ALL RANDOM GENENERATORS
import random

# EC: 123-123-1
# CAS: 3to6_digits-12-1
# REACH: 01-1234567890-12

class Generate:
    def __init__(self):
        pass
    
    def reach(self):
        return '01-'\
                + str(random.randrange(1000000000, 9000000000)) + '-'\
                + str(random.randrange(11,99))

    def cas(self):
        return str(random.randrange(100,999999)) + '-'\
            + str(random.randrange(11,99)) + '-'\
            + str(random.randrange(0,9))
                         
    def ec(self):
        return str(random.randrange(100,999)) + '-'\
              + str(random.randrange(100,999)) + '-'\
              + str(random.randrange(0,9))

    def date(self,locale='EU'):
        if locale == 'US':
            return '%02d'%random.randrange(1,12) + '/'\
                    +'%02d'%random.randrange(1,28) + '/'\
                    + str(random.randrange(2000, 2022))
        else:
           return '%02d'%random.randrange(1,28) + '/'\
                    + '%02d'%random.randrange(1,12) + '/'\
                    + str(random.randrange(2013, 2022))
        

