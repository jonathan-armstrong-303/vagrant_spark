sudo su -

# start spark cluster [on master]
cd /usr/local/spark
./sbin/start-all.sh

# stop spark cluster [on master]
cd /usr/local/spark
./sbin/stop-all.sh

# Check whether services have been started -- should see e.g., output like this:
# 65530 Jps
# 65468 Worker
# 65373 Master

jps
