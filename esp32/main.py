import camera
import socket  # 网络通信
import network  # 网络模块，用于wifi连接
import time  # 时间模块

SSID = 'Drifter'  # 输入wifi名字
password = '123456789'  # 输入WIFI密码
IP = '172.20.10.2'  # IPv4地址
port = 9090  # 发送图像数据的端口号

# 连接wifi
wlan = network.WLAN(network.STA_IF) 
wlan.active(True) 
if not wlan.isconnected():
    print('connecting to network...')
    wlan.connect(SSID, password)
    # 一直等待，直到wifi连接成功
    while not wlan.isconnected():
        pass
print('网络配置:', wlan.ifconfig())

try:
    camera.init(0, format=camera.JPEG)  # 摄像头被配置为以JPEG格式捕获图像
except Exception as e:
    camera.deinit()
    camera.init(0, format=camera.JPEG)

# 分辨率：480x320 像素
camera.framesize(camera.FRAME_HVGA)

# 质量（10-63数字越小质量越高）
camera.quality(15)

# SOCK_DGRAM不作任何数据校验，因此传输数据的效率高
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, 0)  

i = 0
while 1:
    i = i + 1
    buf = camera.capture()  # 获取图像数据
    s.sendto(buf, (IP, port))  # 向服务器发送图像数据
    time.sleep(0.1)
