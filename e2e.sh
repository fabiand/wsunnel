set -x

# Assume OCP with nmstate

bash to.sh deploy

sleep 20

bash to.sh client limit | tee stdout.txt
grep "0 received" stdout.txt || echo PASS
rm stdout.txt
