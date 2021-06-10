
set -e

# start xvfb
/opt/bin/start-xvfb.sh &

# start vnc server
/opt/bin/start-vnc.sh > /dev/null 2>&1 &

echo " "
echo "You can now connect your VNC client to http://localhost:5900 to view the application GUI. Use the password 'secret' if prompted"
echo " "
