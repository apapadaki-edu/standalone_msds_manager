######  H300-02   H310-12   H330-32
from DBInteract import DBInteraction

dbi = DBInteraction()

def substances(substances):
    subs = dict()
    if substances:
        subs = {substances[0][0]: {substances[0][1]: {0: {
            'concentration': substances[0][2],
            'ghs': substances[0][3],
            'scl': substances[0][4],
            'class': substances[0][5],
            'category': substances[0][6]
        }}}}
        if len(substances) > 1:
            counter = 1
            for s in substances[1:]:
                if s[0] not in subs.keys():
                    subs.update({s[0]: {s[1]: {0: {
                        'concentration': s[2],
                        'ghs': s[3],
                        'scl': s[4],
                        'class': s[5],
                        'category': s[6]}}}})
                    counter += 1
                else:
                    if s[1] not in subs[s[0]].keys():
                        subs[s[0]].update({s[1]: {0: {'concentration': s[2], 'ghs': s[3], 'scl': s[4],
                                                      'class': s[5], 'category': s[6]}}})
                        counter += 1
                    else:
                        counter += 1
                        subs[s[0]][s[1]].update({counter: {'concentration': s[2], 'ghs': s[3], 'scl': s[4],
                                                           'class': s[5], 'category': s[6]}})
    return subs


# TODO: Find the substances ATE based on their hazzard category and statement
''' substances must be of the form:
    additive: { cas: {counter: { concentration: float,
                                ghs: str,
                                scl: float,
                                class: str,
                                category: str
                                },
                        counter++: {}, ...
                cas2: {}, ...}
    additive2: ...
    }
'''


def classify_skin_corrosivity(substances):
    skin_corr = {'C1': 0, 'C1A': 0, 'C1B': 0, 'C1C': 0, 'C2': 0}
    subs = set()
    for a, v in substances.items():
        for sub, c in v.items():
            for count, s in c.items():
                con = s.get('concentration')
                scl = 0 if s.get('scl') is None else s.get('scl')
                if s.get('ghs') == 'H314':
                    if s.get('category') == 'Category 1' and con > scl:
                        skin_corr['C1'] += con
                    elif s.get('category') == 'Category 1A' and con > scl:
                        skin_corr['C1A'] += con
                    elif s.get('category') == 'Category 1B' and con > scl:
                        skin_corr['C1B'] += con
                    elif s.get('category') == 'Category 1C' and con > scl:
                        skin_corr['C1C'] += con
                    if con >= 0.01:
                        subs.add(sub)
                if s.get('ghs') == 'H315' and con > scl:
                    skin_corr['C2'] += con
                    if con >= 0.01:
                        subs.add(sub)

    sum_subcat = skin_corr.get('C1A') + skin_corr.get('C1B') + skin_corr.get('C1C')
    if skin_corr.get('C1') != 0:
        if (skin_corr.get('C1') + sum_subcat) >= 0.05:
            return subs, ('H314', 'Category 1')
    if skin_corr.get('C1A') >= 0.05:
        return subs, ('H314', 'Category 1A')
    else:
        if skin_corr.get('C1B') >= 0.05 or (skin_corr.get('C1A') + skin_corr.get('C1B')) >= 0.05:
            return subs, ('H314', 'Category 1B')
        else:
            if skin_corr.get('C1C') >= 0.05 or (skin_corr.get('C1') + sum_subcat) >= 0.05:
                return subs, ('H314', 'Category 1C')

    if 0.01 <= skin_corr.get('C1') + sum_subcat < 0.05 or skin_corr.get('C2') >= 0.1 \
            or (10 * (skin_corr.get('C1') + sum_subcat) + skin_corr.get('C2')) >= 0.1:
        return subs, ('H315', 'Category 2')


def classify_eye_corrosivity(substances):
    eye_corr = {'C1': 0, 'C2': 0, 'SC': 0}
    subs = set()
    for a, v in substances.items():
        for sub, c in v.items():
            for count, s in c.items():
                con = s.get('concentration')
                scl = 0 if s.get('scl') is None else s.get('scl')
                if s.get('ghs') != 'H318':
                    if s.get('ghs') == 'H319' and con > scl:
                        eye_corr['C2'] += con
                    if s.get('ghs') == 'H314' and con > scl:
                        eye_corr['SC'] += con
                    if con >= 0.01:
                        subs.add(sub)
                else:
                    if con > scl:
                        eye_corr['C1'] += con
                    if con >= 0.01:
                        subs.add(sub)

    if eye_corr.get('C1') + eye_corr.get('SC') >= 0.03:
        return subs, ('H318', 'Category 1')
    if 0.01 <= eye_corr.get('C1') + eye_corr.get('SC') < 0.03 or eye_corr.get('C2') >= 0.01 \
            or 10 * (eye_corr.get('C1') + eye_corr.get('SC')) + eye_corr.get('C2') >= 0.01:
        return subs, ('H319', 'Category2')


# TODO: use classification for solids and gasses in H334
def classify_respiratory_sens(substances, physical_state='Liquid'):
    classification = set()
    subs = set()
    for a, v in substances.items():
        for sub, c in v.items():
            for count, s in c.items():
                con = s.get('concentration')
                scl = 0 if s.get('scl') is None else s.get('scl')
                if s.get('ghs') == 'H334' and (s.get('category') == 'Category 1' or s.get('category') == 'Category 1B') \
                        and physical_state == 'Liquid' and con >= 0.01 and con >= scl:
                    classification.add(('H334', s.get('category')))
                if s.get('ghs') == 'H334' and s.get('category') == 'Category 1A' \
                        and physical_state == 'Liquid' and con >= 0.001 and con >= scl:
                    classification.add(('H334', 'Category 1A'))

                if s.get('ghs') == 'H317' and (s.get('category') == 'Category 1' or s.get('category') == 'Category 1B') \
                        and con >= 0.01 and con >= scl:
                    classification.add(('H317', s.get('category')))
                if s.get('ghs') == 'H317' and s.get('category') == 'Category 1A' \
                        and con >= 0.001 and con >= scl:
                    classification.add(('H317', 'Category 1A'))
                if con >= 0.001:
                    subs.add(sub)
    return subs, list(classification)


def classify_environmental_haz(substances):
    classifcation = set()
    subs = set()
    env_cons = {'A1': 0, 'C1': 0, 'C1noM': 0, 'C2': 0, 'C3': 0, 'C4': 0}
    for a, v in substances.items():
        for sub, c in v.items():
            for count, s in c.items():
                con = s.get('concentration')
                scl = 1.0 if s.get('scl') is None else s.get('scl')
                if s.get('ghs') == 'H400':
                    env_cons['A1'] += scl * con
                    if con >= 0.001:
                        subs.add(sub)
                if s.get('ghs') == 'H410':
                    env_cons['C1'] += scl * con
                    env_cons['C1noM'] += con
                    if con >= 0.001:
                        subs.add(sub)
                if s.get('ghs') == 'H411':
                    env_cons['C2'] += con
                if s.get('ghs') == 'H412':
                    env_cons['C3'] += con
                if s.get('ghs') == 'H413':
                    env_cons['C1'] += con
                if con >= 0.01:
                    subs.add(sub)
    if env_cons.get('A1') >= 0.25:
        classifcation.add(('H400', 'Category 1'))
    if env_cons.get('C1') >= 0.25:
        classifcation.add(('H410', 'Category 1'))
        return subs, list(classifcation)
    if 10 * env_cons.get('C1') + env_cons.get('C2') >= 0.25:
        classifcation.add(('H411', 'Category 2'))
        return subs, list(classifcation)
    if 100 * env_cons.get('C1') + 10 * env_cons.get('C2') + env_cons.get('C3') >= 0.25:
        classifcation.add(('H412', 'Category 3'))
        return subs, list(classifcation)
    if env_cons.get('C1noM') + env_cons.get('C2') + env_cons.get('C3') + env_cons.get('C4') >= 0.25:
        classifcation.add(('H413', 'Category 4'))
    return subs, list(classifcation)


def classify(subs):
    s = substances(subs)
    classification = set()
    pics = set()
    involved_subs = list()
    classify_sc = classify_skin_corrosivity(s)
    classify_ec = classify_eye_corrosivity(s)
    classify_rc = classify_respiratory_sens(s)
    classify_envc = classify_environmental_haz(s)

    if classify_sc is not None:
        sc_subs, sc = classify_sc
        classification.add(sc)
        involved_subs.extend(sc_subs)
    if classify_ec is not None:
        ec_subs, ec = classify_ec
        classification.add(ec)
        involved_subs.extend(ec_subs)
    if classify_rc is not None:
        rc_subs, rc = classify_rc
        for i in rc:
            if i is None:
                continue
            classification.add(i)
        involved_subs.extend(rc_subs)
    if classify_envc is not None:
        envc_subs, envc = classify_envc
        for i in envc:
            if i is None:
                continue
            classification.add(i)
        involved_subs.extend(envc_subs)


    classification = list(classification)

    for c in classification:
        if c is None:
            continue
        if c[0] == 'H314' or c[0] == 'H318':
            pics.add('GHS05')
        if c[0] == 'H334':
            pics.add('GHS08')
        if (c[0] == 'H315' or c[0] == 'H319') and 'GHS05' not in pics:
            pics.add('GHS07')
        if c[0] == 'H317' and 'GHS08' not in pics:
            pics.add('GHS07')
        if c[0] == 'H400' or 'H410' or 'H411' or 'H412':
            pics.add('GHS09')
    return involved_subs, classification, pics
