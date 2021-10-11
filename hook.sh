# Matrix-Bot
# By @HadiDotSh

case ${message} in

    ping)
        send "Pong 🏓"
    ;;

    date)
        send "⚡️ $(date)"
    ;;

    *)
        send "🧐 404 not found"
    ;;

esac
