"""
Gibbs Sampling code for final project, CS221 + CS228, Aut2018
Copyright @CS221 + Avoy Datta, Dian Ang Yap and Zheng Yen
"""
import pandas as pd 
import numpy as np
import itertools
import math
import collections
import random

k = 2 #number of weeks for each block of the quarter
T = 24 #Number of hours per day
N_DAYS = 14 #2 weeks
SLOT_WIDTH = 1 #number of hours per slot
EARLIEST_OH = 9
LATEST_OH = 9

daily_limit = 3
predictions_path = "test.csv"

def get_domains(availability):
    """
    Takes in a dict mapping X_i --> list<slot_avail> where slot_avail is a time slot index
    Returns a dict mapping each key in availability to a list<k-tuples>, where each k-tuple is a possible assignment
    """

    domains = {}
    for var, free_times in availability.items():
        vals_lst = []

        free_times = availability[var] #list 
        list_tuples = list(itertools.combinations(free_times, 2*k))
        
        for candidate in list_tuples:
            #Add candidate to list only if it satisfies conditions
            add_cand = True
            daily_OH = collections.defaultdict(int)

            for s_ind in range(len(candidate) - 1):

                c = candidate[s_ind]
                if (math.floor(c / T) == math.floor((candidate[s_ind+1]) / T) and #OH on same day
                    candidate[s_ind+1] - candidate[s_ind] != 1):#non-consecutive assn
                    add_cand = False
                    break
                daily_OH[math.floor(c / T)] += 1

            if (max(daily_OH.values()) <= daily_limit and 
                add_cand == True): 
                vals_lst.append(candidate)

        domains[var] = vals_lst

    return domains

    domains = {}
    for var, free_times in availability.items():
        vals_lst = []

        list_tuples = list(itertools.combinations(free_times, 2*k))

        for candidate in list_tuples:
            
            print(candidate)
            #Add candidate to list only if it satisfies conditions
            add_cand = True
            daily_OH = collections.defaultdict(int)

            for s_ind in range(len(candidate) - 1):
                c = candidate[s_ind]
                if (math.floor(c / T) == math.floor((candidate[s_ind+1]) / T) and #OH on same day
                    candidate[s_ind+1] - candidate[s_ind] != 1):#non-consecutive assn
                    add_cand = False
    #               
                daily_OH[math.floor(c / T)] += 1
                
            daily_OH[math.floor(candidate[len(candidate) - 1] / T)] += 1
            if (max(daily_OH.values()) <= daily_limit and 
                add_cand == True): 
                vals_lst.append(candidate)
        domains[var] = vals_lst
    return domains

def full_weight(slot_hrs, preds):

    slot_hrs_arr = np.array(slot_hrs.values())

    assert(slot_hrs_arr.shape == preds.shape)
    cor_metric = slot_hrs_arr.dot(preds)
    overlap_metric = 

    weight = (cor_metric + LAMBDA) / (overlap_metric + LAMBDA)
    return weight

def update_slot_assn(slot_hrs, new_val, prev_val = None):

    if (prev_val != None): #Only when hours previously assigned
        #prev_assn is a 2-tuple (var, prev_val), where prev_val is a 2k-tuple
        for slot in prev_val[1]:
            slot_hrs[slot] -= 1

    for slot_tuple in new_vals:
        for slot in slot_tuple:
            slot_hrs[slot] += 1

def main():
    availability = generateTAAvail()... #INSERT FUNCTION
    domains = get_domains(availability)
    preds_df = pd.read_csv(predictions_path, header = None, squeeze = True)
    predictions = preds_df.values

    t_slots = np.array([i for i in range(N_DAYS * 24, step = SLOT_WIDTH) if i >= EARLIEST_OH and i <= LATEST_OH])
    slot_hrs = dict([(t, 0) for t in t_slots]) 

    assignment = dict([(key, random.choice(domains[key]) for key in domains)]) #random assignment
    update_slot_assn(slot_hrs, assignment.values())

    #iterate
    for i in range(10): #Over iterations
        for j, var in enumerate(domains.keys()): #Over each var
            dom = domains[var]
            probs = np.zeros((len(dom))) 
            for val_i, val in enumerate(dom): #Over possible values of each var
                assignment[var] = val 
                update_slot_assn(slot_hrs, [val], prev_val)   
                probs[val_i] = full_weight(slot_hrs, predictions, assignment)
            probs = probs / np.linalg.norm(probs)


        print("Correlation: {}", full_weight(t_slots, predictions))

if __name__ == "__main__":
    main()


