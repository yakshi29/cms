#!/usr/bin/python3
# -*- coding: utf-8 -*-
#title           :python-menu.py
#description     :This program acts as an automation manager to carry out operations tasks.
#author          :
#date            :
#version         :0.1
#usage           :
#notes           :
#python_version  :3.6.5 
#=======================================================================

# Import the modules needed to run the script.
import sys
import subprocess


# =======================
#     MENUS FUNCTIONS
# =======================



# Menu definition

class Menu:
     
    def __init__(self):
 
        self.choice=''
        self.level=0
        # Main menu options
        self.menu =['Stop / Start of the cluster','Planned failover','DR Operations (e.g. re-attachment of DR node)', 'Near Zero Downtime Maintenance', 'test']
   
        menu_ss =['clu_check_node','clu_check_primar','clu_start_primary', 'clu_start_secondary','clu_verify_maintainance_resources','clu_remove_maintenance_mode','clu_verify_primary']
        menu_pf =['check_node', 'pre_check', 'trigger_failover','trigger_maintenance','trigger_maintenance_stop_cluster', 'maintenance_check', 'maintenance_activity', 'verify_post_maintenance']
        menu_dr =['dr_opr_pre-check', 'dr_opr_hsr_check', 'dr_opr_recovery_unregister_drnode', 
                'dr_opr_recovery_register_secondary', 'dr_opr_crash_primary', 'dr_opr_crash_verify_failover',
                'dr_opr_recovery_pre-check', 'dr_opr_recovery_enable_secondary', 'dr_opr_recovery_primary_online',
                'dr_opr_recovery_stop_drnode', 'dr_opr_recovery_verify_hsr_primary', 'dr_opr_recovery_register_drnode',
                'dr_opr_verify_primary', 'dr_opr_verify_secondary', 'dr_opr_verify_drnode', 'dr_opr_cleanup_failed_action']
        menu_zd =['check_node' , 'user_store' , 'update_secondary' , 'failover' , 'update_primary' , 'reattach_node' , 'verify_post_maintenance']
        menu_test =['cm1', 'cm2','cm3']

        self.menu_actions = {
            'main_menu': self.main_menu,
            '1': {'data':menu_ss,'script':'HDBHA_cluster_start_stop_v180424.sh','payload':'HDBHA_payload.cfg'},
            '2': {'data':menu_pf,'script':'planned_failover.sh','payload':'payload.cfg'},
            '3': {'data':menu_dr,'script':'HDBHA_dr_operations_v180424.sh','payload':'HDBHA_payload.cfg'},
            '4': {'data':menu_zd,'script':'HDBHA_nzd_v180425.sh','payload':'payload.cfg'},
            '5': {'data':menu_test,'script':'drtest.sh','payload':'payload.cfg'},
            '*': self.back,
            '0': self.quit
        }
            
    def main_menu(self,*argv):
        ch=''
        print ("-------------------------------------------------")
        print ("  Please choose the option you want to work with:")

        if len(argv) == 0:
            self.level = 0
            for i in range(len(self.menu)):
                print ("%d. %s" %(i+1, self.menu[i]))
        else:
            for i in range(len(argv[0])):
                print ("%d. %s" %(i+1, argv[0][i]))
            print ("*. Back")
        print ("0. Quit")
        print ("-------------------------------------------------")
        try:
            if self.level == 0:
                self.choice = input(" >> ") 
                self.onSelection(self.choice) 
            else:
                ch = input(" >> ")
                self.onSelection(ch)    
        except KeyError:
            print("Please enter correct option")
            self.menu_actions['main_menu']()
        except SystemExit:
            print("Thank you.")
        except:
            print ("Unexpected error:", sys.exc_info()[0])
            raise


    def onSelection(self,choice):       
        if choice == '' or choice == '#':
            self.menu_actions['main_menu']()
        elif choice == '0' or choice == '*':
            self.menu_actions[choice]()
        else:
            if self.level == 0:
                self.level+=1
                self.main_menu(self.menu_actions[self.choice]['data'])        
            else:
                self.level+=1
                self.sub_menu(self.menu_actions[self.choice],choice)
    
    def sub_menu(self,sub_data,param): 
        print ("Executing the script...............")
        scr="./%s %s" % (sub_data['script'],sub_data['data'][int(param)-1])   
        print (scr)
        #test script just for checking how it will execute
        subprocess.Popen(["bash", sub_data['script']]).wait()
        print ("Press * to return to main menu or 0 to quit")
        ch = input(" >> ")
        self.onSelection(ch)
     
     # Back to main menu
    def back(self):
        self.main_menu()
        
    # Exit program
    def quit(self):      
        sys.exit(0)

# Main Program
if __name__ == "__main__":
    # Launch main menu
  Menu().main_menu()   
