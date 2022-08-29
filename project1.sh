<<doc
Name of the Project: Command Line Test Using Linux Shell
Name of the Author: Sachin Kumar Dash
Submission Date: 29th Aug 2022
Project Description: Giving prompt to user to choose between signup/signin/exit
On choosing signup the user have to enter an unique username which should not match any name on the database.
On choosing signin the user have to sign in  using existing username and password.
On signin the user will be prompted to take a test or exit.
On choosing the take test option, the question will appear one by one with their option. User have to select 1 option within 10 sec or else program will take default answer which is "e" and proceed to another question.
on completion of the test the system will show the questions,user answer,correct answer and if the user submitted answer is right or wrong  
doc

answer=(`cat answers.txt`)                                #answer file storing in an array
ans_length=${#answer[@]}                                  #total no. of ans storing in an array

usr=(`cat username.csv`)                                  #user name file storing in an array
pwd=(`cat password.csv`)                                  #password file storing in an array

echo -e "\e\033[1;92m  1) Sign up \n  2) Sign in \n  3) Exit \033[1;92m\e[0m" #giving choice to user
echo -e " \033[1;92m Please Enter Your Choice: \e[0m"                         #asking user to choose one
read n                      
    case $n in                                                                 #if user choice is 1
	1) count=1                                                          #initializing one variabe
	    while [ $count -eq 1 ]    #setting condition for signup
	    do
		count=0
                
		read -p "Please Enter Username: " username
		for i in ${usr[@]}
		do
		    if [ $i = $username ]   #checking if username present in the database
		    then
			echo -e "\e[1;31mUsername already exists.Please enter a different username\e[0m"
			count=1	#repeating the process if enter username already present in the database
		    fi
		done
	  done
	  flag=1
	  while [ $flag -eq 1 ]
	  do
	      flag=0
	      if [ ${#username} -gt 1 ]
	      then
		  echo
		  echo -e "\e[1mPlease Enter your Password\e[0m:"    #asking user to enter password
		  read -s pass
		  echo
		  echo -e "\e[1mConfirm Password\e[0m:"   #asking user to re-enter the password
		  read -s pass_1
		  echo
		  if [ $pass != $pass_1 ]    #if both password not match then repeat the process again
		  then
		      flag=1
		      echo -e "\e[1;31mInvalid input!!Try again (password not matching re-entered password)\e[0m"
		  fi
	      fi
	  done
	  echo -e "\e[36;1mSignedup Successfully\e[0m"   #if enter password matches and username is unique then signup successful
	  echo $username>>username.csv   #storing the new username and password
	  echo $pass>>password.csv ;;
      2) flag2=1             #if user choice is 2 i.e. the signin part
	  while [ $flag2 -eq 1 ]
	  do

	      flag2=1
	      read -p "Please Enter Username: " username_1    #asking the user to enter one user name
	      for i in `seq 0 $((${#usr[@]}-1))`
	      do
		 if [ $username_1 = ${usr[$i]} ]               #checking if entered username is present in the database
		 then
		     flag2=0
		     position=$i
		     count_3=1
		     while [ $count_3 -eq 1 ]
		     do
			 count_3=1
			 echo
			 echo -e "\e[1mPlease Enter your Password\e[0m:"         #on matching username asking for respective password
			 read -s password
			 if [ $password = ${pwd[$position]} ]   #checking if entered password is right password for the respective user
			 then
			     count_3=0
			     echo
			     echo -e "\e[36;1mYou have Signedin Successfully\e[0m"  #if both username and password matches sign in successful
			     read -p "1) Take Test   
2) Exit
Please select any option: " num          #asking the user to enter a choice from the given option
			     case $num in   
				 1) arrayls=(`ls`)    #if user choice is 1
				     ques_length=`cat questions.txt | wc -l`     #storing total line of question in an array
				     for i in ${arrayls[@]}
				     do
					 if [ "$username_1"answers".txt" = $i ]         #clearing the userans file if any previous ans present
					 then
					     rm -r "$username_1"answers".txt"
					 fi
				     done
				     for i in `seq 5 5 $ques_length`
				     do
					
     					 head -$i questions.txt | tail -5    #displaying ques 1 by one i.e. every 5 line
    					 for i in `seq 10 -1 1`   #setting 10sec waiting time
    					 do					 
    					     echo -n -e "\rEnter Your Answer: $i \c"   #asking the user to enter the ans within 10 sec
					     
    					     read -t 1 option
				     
    					     if [ -n "$option" ]
    					     then
						 break
    					     else
						 
    						 option="e"   # default answer if user not entering anything 
    					     fi
    					 done
					 echo
    					 echo $option>>$username_1"answers".txt    #storing all ans of user in one file
   				     done
				    echo -e "\e[36;1mYou have Completed the Test Sucessfully\e[0m"
				    echo

				    userans=(`cat $username_1"answers".txt`)
				    
				   
				    
				    echo "Displaying the results."
				    echo 
				    mark=0
				    ques=1
				    for i in `seq 0 1 $((ans_length-1))`
				    do
				       	head -$ques questions.txt | tail -1
				        ques=$((ques+5))	
					if [ ${userans[$i]} = ${answer[$i]} ]   #comparing if userans matches the correct ans
					then    
					    echo "User answer is ${userans[$i]}
corect answer is ${answer[$i]}"
                                          echo -e "\e\033[1;92mYour answer is Correct\033[1;92m\e[0m"   #for correct ans
					    mark=$((mark+1))  # 1markfor every correct ans
					elif [ ${userans[$i]} = e ]
				       	then
					       echo "Timeout
corect answer is ${answer[$i]}"
                                        else
					    echo -e "User answer is ${userans[$i]}
corect answer is ${answer[$i]}"
					    echo -e "\e[1;31mYour answer is incorrect\e[0m"  # for incorrect ans
					fi
				    done
			
				    echo
			
             echo -e "                        ***  \e\033[1;92mYour total score is \033[1;92m\e[0m \e[1;5;91m $mark / $ans_length\e[0m  ***         "   #displaying the total score
 
             echo
	    ;;
   			     esac
   			 else
   			     echo -e "\e[1;31mIncorrect!!Try again\e[0m"
			 fi
		     done
		 fi
	     done
	     if [ $flag2 -eq 1 ]
	     then
		 echo -e "\e[1;31mUsername not present!!Try again\e[0m"
	     fi
	 done;;
     3) exit
 esac
