import os
import redis

def connect_redis(conn_dict):
    conn = redis.StrictRedis(host=conn_dict['host'],
                             port=conn_dict['port'],
                             db=conn_dict['db'])
    return conn


def conn_string_type(string):
    format = '<host>:<port>/<db>'
    try:
        host, portdb = string.split(':')
        port, db = portdb.split('/')
        db = int(db)
    except ValueError:
        raise argparse.ArgumentTypeError('incorrect format, should be: %s' % format)
    return {'host': host,
            'port': port,
            'db': db}


def migrate_redis(lxc):
    src = connect_redis(conn_string_type(lxc['lxcIP']))
    dst = connect_redis(conn_string_type(lxc['cloudIP']))
    for key in src.keys('*'):
        ttl = src.ttl(key)
        # we handle TTL command returning -1 (no expire) or -2 (no key)
        if ttl < 0:
            ttl = 0
        print "Dumping key: %s" % key
        value = src.dump(key)
        print "Restoring key: %s" % key
        try:
            dst.restore(key, ttl * 1000, value)
        except redis.exceptions.ResponseError:
            print "Failed to restore key: %s" % key
            pass
    return

def release_ports(lxc):
    """
    Release ports from Edge node
    """
    for p in lxc['Ports']:
        os.system('iptables -t nat -D PREROUTING -i eth0 -p tcp --dport %d -j DNAT --to %s:%d' % (p, lxc['IP'], p))
    print "Done port releasing."

def terminate(lxc):
    migrate_redis(lxc)
    release_ports(lxc)
    os.system('lxc-stop -n %s' % lxc['App'])
    os.system('lxc-destroy -n %s' % lxc['App'])
    print '%s is terminated.' % lxc['App']  
