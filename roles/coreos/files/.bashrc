
if [[ $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

func-docker-enter() {
    docker-enter $1
}
alias de=func-docker-enter

alias di='docker images'
alias dia='docker images -a'

func-docker-logs() {
    docker logs -f $1
}
alias dlf=func-docker-logs

alias dp='docker ps'
alias dpa='docker ps -a'

func-docker-rm() {
    docker stop $1
    docker rm $1
}
alias drm=func-docker-rm


func-etcdctl-ls() {
    etcdctl ls $1 --recursive
}
alias els=func-etcdctl-ls

func-etcdctl-get() {
    etcdctl get $1
}
alias eg=func-etcdctl-get


func-fleetctl-cat() {
    fleetctl cat $1
}
alias fc=func-fleetctl-cat

func-fleetctl-destroy() {
    fleetctl stop $1
    fleetctl destroy $1
    fleetctl unload $1
}
alias fd=func-fleetctl-destroy

alias flu='fleetctl list-units'
alias fluf='fleetctl list-unit-files'
alias flm='fleetctl list-machines'
func-fleetctl-stop() {
    fleetctl stop $1
}
alias fs=func-fleetctl-stop


func-systemctl-status() {
    systemctl status -l $1
}
alias ss=func-systemctl-status
