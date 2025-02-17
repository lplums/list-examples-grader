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
cd ..

cp student-submission/ListExamples.java ./

javac -cp $CPATH *.java > compile_output.txt
ERROR=`grep -c error compile_output.txt`
if [[ $ERROR -eq 0 ]]
then 
  echo "Compile success"
else 
  echo "Compile failed"
  exit
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > execute_output.txt
FAILURES=`grep -c FAILURES execute_output.txt`
if [[ $FAILURES -eq 0 ]]
then
  echo "All tests passed"
  echo "--------------"
  echo "|Score: 2/2 |"
  echo "--------------"
  echo ""
else
  RESULT_LINE=`grep "Tests run:" execute_output.txt`
  SCORE=${RESULT_LINE:25:1}
  cat execute_output.txt
  echo "---------------"
  echo "|Score: $SCORE/2 |"
  echo "---------------"
  echo ""
fi
