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
import sys
import matplotlib.pyplot as plt

sys.path.append('./TAAssignments/')
from generateTAAvail import *

#=========================================Parameters for TA availability======================================
numTAs = 13
start = 9
## End is the index from 12AM that we are scheduling TA at the latest
## 14 = 9pm
end = 21

numWeeks = 2
daysPerWeek = 7
## 9am next day = 30 = 21+9
## 30 is 9am next day = 30%21 - 9 
## Tuesday = 
possClassLengths = range(1,4)
possClassLengths = range(1,4)
possNumClasses = range(6,11)
possClassTimes = [[0,2,4],[0,2],[1,3],[0,1,2,3,4],[0],[1],[2],[3],[4],[5],[6]]
possClassStartHours = range(8,21)
offDay = 5

#======================================Parameters for domains==============================================

k = 4 #number of hours a week per TA
T = 24 #Number of hours per day
N_DAYS = 14 #2 weeks
SLOT_WIDTH = 1 #number of hours per slot
EARLIEST_OH = 9
LATEST_OH = 21
daily_limit = 3
MAX_PER_SLOT = 3
LAMBDA = 1


max_iters = 50

# Takes in dict mapping slots --> num of tas assigned, and an array of predictions for each slot(linearly arranged)
# Returns a weight equal proportional to correlation between the tas per slot and and inversely proportional to number of tas assigned to that hr

def full_weight(slot_hrs, preds):

    slot_hrs_arr = np.array(list(slot_hrs.values()))
    # print(slot_hrs.values(), slot_hrs_arr)
    # print(slot_hrs_arr.shape, preds.shape)
    assert(slot_hrs_arr.shape == preds.shape)

    # if (max(slot_hrs_arr) > MAX_PER_SLOT): return 0 #More than MAX_PER_SLOT TAs assigned in one of the slots
    # cor_metric = slot_hrs_arr.dot(preds) * 1.0 / (np.linalg.norm(preds) * np.linalg.norm(slot_hrs_arr)) 
    cor_metric = slot_hrs_arr.dot(preds) * 1.0 / (np.linalg.norm(preds) * np.linalg.norm(slot_hrs_arr)) 

    # print("cor", cor_metric)
    overlap_metric = 1.0 #for time being

    #Not using LAMBDA for now
    weight = cor_metric
    return weight

def update_slot_assn(slot_hrs, new_val, prev_val = None):
    if (prev_val != None): #Only when hours previously assigned
        #prev_assn is a 2-tuple (var, prev_val), where prev_val is a 2k-tuple
        slot_hrs[prev_val] -= 1
        slot_hrs[new_val] += 1

    else:
        for slot_list in new_val:
            for slot in slot_list:
                slot_hrs[slot] += 1


def broken_daily_schedule(slot_list):
    """
    Takes in list of assigned slots. Returns True if any slots assigned on same day are non-consecutive, False otherwise
    """

    arr = np.array(slot_list)
    arr = np.sort(arr)
    arr_days = np.floor(arr / T)
    arr_hrs = np.mod(arr, T)

    for i in range(arr.shape[0] - 1):
        if arr_days[i] == arr_days[i + 1] and arr_hrs[i + 1] - arr_hrs[i] != 1:
            return True

    return False

def designate_slots_and_assignments(predictions_path, slots_path, correlations_path):
    # read_path = "107Spr18_domains.txt" #Uncomment if previously run

    # complete_preds_df = pd.read_csv(predictions_path, header = None, squeeze = True)
    # complete_preds = complete_preds_df.values

    complete_preds = np.ndarray.flatten(np.load(predictions_path))
    # complete_preds = complete_preds[0: 13]
    complete_preds = complete_preds/ np.linalg.norm(complete_preds, 1)
    len_quarter = complete_preds.shape[0]       
    print("Number of timeslots: ", complete_preds.shape[0])
    

    slots_per_period = numWeeks * (end - start + 1) * 6
    # slots_per_period = 13

    complete_periods = math.floor(len_quarter * 1.0 / slots_per_period)
    # print(complete_periods)
    edge_slots_remaining = (len_quarter * 1.0) % slots_per_period

    availability = generateTAAvail(numTAs, start, end, numWeeks, daysPerWeek, possClassLengths, possNumClasses, possClassTimes, possClassStartHours, offDay) 
    domains = availability 
    #domains is just a map from var --> list of assignable slots for that var
    slot_hrs_final = None

    off_days = [5, 12] #[offDay + i*7 for i in range(numWeeks)]
    # print(off_days)
    
        
    slot_hrs_total = []
    n_slots = N_DAYS * 24
    t_slots_lst = []
    for i in range(n_slots):
        if (i % T) >= EARLIEST_OH and (i % T) <= LATEST_OH and not math.floor(i / T) in off_days:
            t_slots_lst.append(i)

    t_slots = np.array(t_slots_lst)

    correlations = []#Stores progress of Gibbs Sampling

    # for period in range(complete_periods + 1): #Over each 2-week long period
    for period in range(complete_periods + 1): #Over each 2-week long period

        period_cors = []
        start_idx = period * slots_per_period
        end_idx = start_idx + slots_per_period 
        if period == complete_periods: #Edge case
            #n_slots = int(edge_slots_remaining)
            # print("Edge: ", int(edge_slots_remaining))
            print(edge_slots_remaining, len(t_slots_lst))
            end_idx = len_quarter
            t_slots_lst = t_slots_lst[:int(edge_slots_remaining)]
            t_slots = t_slots[:int(edge_slots_remaining)]

        slot_hrs = {}
        for t_slot in t_slots:
            slot_hrs[t_slot] = 0

        print(n_slots)
        # print(len(t_slots), len(slot_hrs))

        # assignment = dict([(key, random.sample(domains[key], 2*k)) for key in domains]) #random assignment
        assn_list = []
        for key in domains:
            samples = random.sample(domains[key], 2*k)
            for s_i, s in enumerate(samples): 
                if s not in t_slots_lst:
                    samples[s_i] = random.choice(t_slots_lst)

            assn_list.append((key, samples))
        assignment = dict(assn_list)
        #Iterate over 2-week slots:

        predictions = complete_preds[start_idx : end_idx]


        print("Initial assn: ", assignment)
        update_slot_assn(slot_hrs, assignment.values())
        # print("Slot hrs: ", slot_hrs)

        # print("Slot hrs: ", slot_hrs)
        print("total hours assigned:", np.sum(np.array(list(slot_hrs.values()))))

        for t in range(max_iters):
            print("Iteration number: {}".format(t))
            for _, var in enumerate(domains.keys()): #Over each var
                dom = domains[var]
                # print(len(dom))
                assigned_slots = assignment[var]
                old_probs = np.zeros((len(dom),)) / len(dom)
                for j,_ in enumerate(assigned_slots): #Over each assigned slot for TA
                    #Calculate prob distrib over all available time slots NOT already assigned
                    prev_prev_val = assigned_slots[j]
                    probs = np.ones((len(dom),)) / len(dom)
                    # print(len(dom))
                    for val_i, new_val in enumerate(dom): #Over possible values of each slot
                        prev_val = assigned_slots[j]
                        set_prob_zero = False
                        if (new_val in assigned_slots and assigned_slots.index(new_val) != j): set_prob_zero = True
                        # if (new_val in assigned_slots or new_val not in t_slots_lst): 
                        #     #Element assigned elsewhere for same TA  or #Daily schedule broken
                        #     probs[val_i] = 0 #val cannot be assigned for this posn
                        #     update_slot_assn(slot_hrs, prev_val, prev_val)
                        #     continue

                        assigned_slots[j] = new_val                      
                        if set_prob_zero == True or new_val not in t_slots_lst: 
                            #Element assigned elsewhere for same TA  or #Daily schedule broken
                            assigned_slots[j] = prev_val
                            probs[val_i] = 0 #val cannot be assigned for this posn
                            # update_slot_assn(slot_hrs, prev_val, prev_val)

                        else:
                            update_slot_assn(slot_hrs, new_val, prev_val)
                            probs[val_i] = full_weight(slot_hrs, predictions)
                        # print(probs[val_i])
                        # print(np.sum(probs))

                    # print(probs)
                    if (np.sum(probs) == 0): new_val = np.random.choice(t_slots_lst)
                    else:
                        # print(old_probs)
                        weights = np.copy(probs)
                        # print(weights)
                        probs = (probs - old_probs)
                        # probs = probs + abs(np.min(probs, axis = 0))
                        probs = np.where(probs < 0, 0.00, probs)
                        # print(probs)

                        if (np.sum(probs) == 0): 
                            update_slot_assn(slot_hrs, prev_prev_val, assigned_slots[j])
                            assigned_slots[j] = prev_prev_val
                            continue
                        probs = probs / np.sum(probs)
                        new_val = dom[np.argmax(np.random.multinomial(1, probs))]
                        # print(np.argmax(np.random.multinomial(1, probs)))
                        # new_val = dom[np.argmax(probs)]

                    prev_val = assigned_slots[j]
                    update_slot_assn(slot_hrs, new_val, prev_val)
                    assigned_slots[j] = new_val
                    # print(slot_hrs)

                    old_probs = full_weight(slot_hrs, predictions)

                assignment[var] = assigned_slots

            biweekly_correlation = full_weight(slot_hrs, predictions)
            print("Period {}, Iter: {}, Correlation: {}".format(period, t, biweekly_correlation))
            period_cors.append(biweekly_correlation)

            print(slot_hrs)
            print(assignment)
        correlations.append(period_cors)
        slot_hrs_total += slot_hrs.values()

    # if (t == max_iters - 1): slot_hrs_final = slot_hrs_total
    print(len(slot_hrs_total))
    print(assignment, slot_hrs_total) #Only returns final assn

    # with open(slots_path, 'w') as file_handler:
    #     for num in slot_hrs_total:      
    #         file_handler.write("{}\n".format(num))
    slot_hrs_total = np.array(slot_hrs_total)
    np.save(slots_path, slot_hrs_total)

    correlations = np.array(correlations)
    np.save(correlations_path, correlations)
    print(complete_preds)


def analyse_slots(slots_path, correlations_path, predictions_path):
    val_lst = []
    # with open(slots_path, 'r') as f_reader:
    #     while(True):
    #         key_str = f_reader.readline()
    #         if (key_str == ""): break
    #         val_lst.append(int(key_str)) 
            
    # assigned_slots = np.array(val_lst)
    assigned_slots = np.load(slots_path)
    correlations = np.load(correlations_path)
    complete_preds = np.ndarray.flatten(np.load(predictions_path))

    len_quarter = complete_preds.shape[0]   
    assert assigned_slots.shape[0] == complete_preds.shape[0]

    print("Number of timeslots: ", complete_preds.shape[0])

    dataset_name = "CS224NWinter2018"
    data_path = "../Datasets/fullDataToPredict/Full" + dataset_name + "dataset.csv"
    df_servers = pd.read_csv(data_path, usecols = ["servers"], squeeze = True)
    df_LI = pd.read_csv(data_path, usecols = ["loadInflux"], squeeze = True)

    servers_actual, LI_actual = df_servers.values, df_LI.values

    t_slots = np.array([i for i in range(LI_actual.shape[0])])

    t_iters = [i for i in range(max_iters)]

    #print correlation data
    plt.figure()
    plt.plot(t_iters, correlations[0, :], 'r-', t_iters, correlations[1, :], 'b-', t_iters, correlations[2, :], 'g-', t_iters, correlations[3, :], 'k-', t_iters, correlations[4, :], 'm-',)

    plt.xlabel("iterations")
    plt.ylabel("Weight")
    plt.title("Full weight of each two-week period with {} iterations of Gibbs Sampling".format(max_iters))
    plt.legend(('Wks-2/3', 'Wks-4/5', 'Wks-6/7', 'Wks-8/9', 'Wks-10/11'), loc='best', shadow=False)
    plt.grid(True)
    plt.savefig("correlations.png")
    plt.close()

    #Resized to fit sampe plot as num_servers assigned
    resz_preds = 0.02*complete_preds 
    resz_LI = 0.01*LI_actual
    plt.figure()
    plt.subplot(211)
    plt.plot(t_slots, assigned_slots, 'b.', t_slots, resz_preds, 'r-', linewidth = 1.0)
    plt.legend(('TAs per slot(optimized)', 'Resized predicted L.I.'), loc='best')
    plt.grid(True)
    plt.title("Optimized and actual schedules, quarter: " + dataset_name)
    plt.subplot(212)
    plt.grid(True)
    plt.xlabel("Time slots throughout the quarter")
    plt.ylabel("Number of TAs assigned per slot")
    plt.plot(t_slots, servers_actual, 'g.', t_slots, resz_LI, 'm-', linewidth = 1.0)
    plt.legend(('Servers per slot(actual)', 'Resized actual L.I.'), loc='best')
    plt.savefig("slot_comparison.png")
    plt.close()
    print(np.sum(assigned_slots), np.sum(servers_actual))
    # print(assigned_slots.dot(trunc_LI / np.linalg.norm(trunc_LI), trunc_servers.dot(trunc_LI / np.linalg.norm))
    
    # raise Exception("")
    #plot zoomed in versions of slots
    trunc_t_slots = t_slots[400:500]
    trunc_assigned_slots = assigned_slots[400:500]
    trunc_LI_actual = resz_LI[400:500]
    trunc_servers_actual = servers_actual[400:500]
    trunc_LI_preds = resz_preds[400:500]
    plt.figure()
    plt.subplot(211)
    plt.plot(trunc_t_slots, trunc_assigned_slots, 'b.', trunc_t_slots, trunc_LI_preds, 'r-', linewidth = 1.0)
    plt.legend(('Slots per slot(optimized)', 'Resized predicted L.I.'), loc='best')
    plt.grid(True)
    plt.title("(Zoomed in) Optimized and actual schedules, quarter: " + dataset_name)
    plt.ylabel("Recommended assignmets")

    plt.subplot(212)
    plt.grid(True)
    plt.xlabel("Time slots throughout the quarter")
    plt.ylabel("TAs during quarter")
    plt.plot(trunc_t_slots, trunc_servers_actual, 'g.', trunc_t_slots, trunc_LI_actual, 'm-', linewidth = 1.0)
    plt.legend(('Servers per slot(actual)', 'Resized actual L.I.'), loc='best')
    plt.savefig("slot_comparison_zoomed.png")
    plt.close()

    #Cosine similarity printouts
    cos_sim_opt_pred = (assigned_slots.dot(complete_preds) * 1.0) / (np.linalg.norm(complete_preds) * np.linalg.norm(assigned_slots)) 
    cos_sim_opt_act = (assigned_slots.dot(LI_actual) * 1.0) / (np.linalg.norm(LI_actual) * np.linalg.norm(assigned_slots))
    cos_sim_act = (servers_actual.dot(LI_actual) * 1.0) / (np.linalg.norm(LI_actual) * np.linalg.norm(servers_actual))
    zoomed_cos_sim_pred = (trunc_assigned_slots.dot(trunc_LI_preds) * 1.0) / (np.linalg.norm(trunc_LI_actual) * np.linalg.norm(trunc_assigned_slots))
    zoomed_cos_sim_act = (trunc_servers_actual.dot(trunc_LI_actual) * 1.0) / (np.linalg.norm(trunc_LI_actual) * np.linalg.norm(trunc_servers_actual))
    print("Cosine similarity, predicted: {}".format(cos_sim_opt_pred))
    print("Cosine similarity, actual: {}".format(cos_sim_act))
    print("(zoomed)Cosine similarity, predicted: {}".format(zoomed_cos_sim_pred))
    print("(zoomed) Cosine similarity, actual: {}".format(zoomed_cos_sim_act))

    with open("similarity.txt", 'w') as file_handler:       
        file_handler.write("Cosine similarity, opt wrt predsa: {}\n".format(cos_sim_opt_pred))
        file_handler.write("Cosine similarity, opt wrt actual: {}\n".format(cos_sim_opt_act))
        file_handler.write("Cosine similarity, servers wrt actual: {}\n".format(cos_sim_act))


if __name__ == "__main__":

    predictions_path = "CS224NWinter2018dataset.npy"
    slots_path = "slot_hrs_total.npy"
    correlations_path = "correlations.npy"
    #Run first function to assign time slots, second function for analysis
    # designate_slots_and_assignments(predictions_path, slots_path, correlations_path)
    analyse_slots(slots_path, correlations_path, predictions_path)


# def main():
#     read_path = None
#     # read_path = "107Spr18_domains.txt" #Uncomment if previously run
#     availability = generateTAAvail(numTAs, start, end, numWeeks, daysPerWeek, possClassLengths, possNumClasses, possClassTimes, possClassStartHours) if read_path == None else None 

#     domains = get_domains(availability, read_path = read_path)

#     # preds_df = pd.read_csv(predictions_path, header = None, squeeze = True)
#     # predictions = preds_df.values

#     # t_slots = np.array([i for i in range(N_DAYS * 24, SLOT_WIDTH) if i >= EARLIEST_OH and i <= LATEST_OH])
#     # slot_hrs = dict([(t, 0) for t in t_slots]) 
#     # domains = get_domains(availability)
#     # assignment = dict([(key, random.choice(domains[key])) for key in domains]) #random assignment

#     print(domains)
#     # update_slot_assn(slot_hrs, assignment.values())

#     # #iterate
#     # for i in range(10): #Over iterations
#     #     for j, var in enumerate(domains.keys()): #Over each var
#     #         dom = domains[var]
#     #         probs = np.zeros((len(dom))) 
#     #         for val_i, val in enumerate(dom): #Over possible values of each var
#     #             assignment[var] = val 
#     #             update_slot_assn(slot_hrs, [val], prev_val)   
#     #             probs[val_i] = full_weight(slot_hrs, predictions, assignment)
#     #         probs = probs / np.linalg.norm(probs)


#     #     print("Correlation: {}", full_weight(t_slots, predictions))

# def get_domains(availability, read_path = None):
#     """
#     Takes in a dict mapping X_i --> list<slot_avail> where slot_avail is a time slot index
#     Returns a dict mapping each key in availability to a list<k-tuples>, where each k-tuple is a possible assignment
#     """
#     domains = {}
#     if (read_path != None): #read from text file
#         with open(read_path, 'r') as f_reader:
#             while(True):
#                 key_str = f_reader.readline()
#                 if (key_str == ""): break
#                 key, num_vals = tuple([int(int_str) for int_str in key_str.split()])
#                 val_lst = []
#                 for val in range(num_vals):
#                     val_str = f_reader.readline()
#         #             print(val_str)
#                     vals = tuple([int(int_str) for int_str in val_str.split()])
#         #             print(vals)
#                     val_lst.append(vals)
#                     print(val_lst)
#                 domains[key] = val_lst
#     else:
#         save_path = "107Spr18_domains.txt"
#         ctr = 0
#         for var, free_times in availability.items():
            
#             vals_lst = []

#             list_tuples = list(itertools.combinations(free_times, 2*k))
            
#             print("Number of possible vals: {}".format(len(list_tuples)))
#             for candidate in list_tuples:
#                 #Add candidate to list only if it satisfies conditions
#                 ctr += 1
#                 print("Domain cycle: ", ctr)
#                 add_cand = True
#                 daily_OH = collections.defaultdict(int)

#                 for s_ind in range(len(candidate) - 1):

#                     c = candidate[s_ind]
#                     if (math.floor(c / T) == math.floor((candidate[s_ind+1]) / T) and #OH on same day
#                         candidate[s_ind+1] - candidate[s_ind] != 1):#non-consecutive assn
#                         add_cand = False
#                         break
#                     daily_OH[math.floor(c / T)] += 1
#                 daily_OH[math.floor(candidate[len(candidate) - 1] / T)] += 1
#                 if (max(daily_OH.values()) <= daily_limit and 
#                     add_cand == True): 
#                     vals_lst.append(candidate)

#             domains[var] = vals_lst

#         with open(save_path, 'w') as file_handler:
#             for key, dom in domains.items():      
#                 file_handler.write("{} {}\n".format(key, len(dom)))
#                 for val in dom:
#                     for slot in val:
#                         file_handler.write("{} ".format(slot))
#                     file_handler.write("\n")

#     return domains