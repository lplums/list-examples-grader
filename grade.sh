CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -f 'ListExamples.java' ]]
then 
  echo "ListExamples.java found"
else
  echo "ListExamples.java not found"
  exit 1
fi

javac -cp $CPATH *.java > compile_output.txt
ERROR=`grep -c error compile_output.txt`
if [[ $ERROR -eq 0 ]]
then 
  echo "Compile success"
else 
  echo "Compile failed"
  exit 2
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > execute_output.txt
if [[ grep -c FAILURES execute_output.txt -eq 0 ]]
then
  echo "All tests passed"
else
  SCORE = grep -o "Tests Run:." execute_output.txt | sed "s/prefix://"
  cat 
  echo "Score: $SCORE/2"
fi
