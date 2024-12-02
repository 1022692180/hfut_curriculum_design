import math
import cv2
import mediapipe as mp
import time
import socket
import numpy as np

# 计算两个点之间的距离
def points_distance(x0, y0, x1, y1):
    return math.sqrt((x0 - x1) ** 2 + (y0 - y1) ** 2)

# 计算两条线段之间的夹角，以弧度表示
def compute_angle(x0, y0, x1, y1, x2, y2, x3, y3):
    AB = [x1 - x0, y1 - y0]
    CD = [x3 - x2, y3 - y2]

    dot_product = AB[0] * CD[0] + AB[1] * CD[1]

    AB_distance = points_distance(x0, y0, x1, y1) + 0.001  # 防止分母出现0
    CD_distance = points_distance(x2, y2, x3, y3) + 0.001

    cos_theta = dot_product / (AB_distance * CD_distance)

    theta = math.acos(cos_theta)

    return theta

"""
检测所有手指状态（判断每根手指弯曲 or 伸直）
    大拇指只有弯曲和伸直两种状态
    其他手指除了弯曲和伸直还包含第三种状态：手指没有伸直，但是也没有达到弯曲的标准
"""
def detect_all_finger_state():
    finger_first_angle_bend_threshold = math.pi * 0.25  # 大拇指弯曲阈值
    finger_other_angle_bend_threshold = math.pi * 0.5  # 其他手指弯曲阈值
    finger_other_angle_straighten_threshold = math.pi * 0.2  # 其他手指伸直阈值

    first_is_bend = False
    first_is_straighten = False
    second_is_bend = False
    second_is_straighten = False
    third_is_bend = False
    third_is_straighten = False
    fourth_is_bend = False
    fourth_is_straighten = False
    fifth_is_bend = False
    fifth_is_straighten = False
    finger_first_angle = compute_angle(all_points['point0'][0], all_points['point0'][1], all_points['point1'][0], all_points['point1'][1],
                                       all_points['point2'][0], all_points['point2'][1], all_points['point4'][0], all_points['point4'][1])
    finger_sencond_angle = compute_angle(all_points['point0'][0], all_points['point0'][1], all_points['point5'][0], all_points['point5'][1],
                                         all_points['point6'][0], all_points['point6'][1], all_points['point8'][0], all_points['point8'][1])
    finger_third_angle = compute_angle(all_points['point0'][0], all_points['point0'][1], all_points['point9'][0], all_points['point9'][1],
                                       all_points['point10'][0], all_points['point10'][1], all_points['point12'][0], all_points['point12'][1])
    finger_fourth_angle = compute_angle(all_points['point0'][0], all_points['point0'][1], all_points['point13'][0], all_points['point13'][1],
                                        all_points['point14'][0], all_points['point14'][1], all_points['point16'][0], all_points['point16'][1])
    finger_fifth_angle = compute_angle(all_points['point0'][0], all_points['point0'][1], all_points['point17'][0], all_points['point17'][1],
                                       all_points['point18'][0], all_points['point18'][1], all_points['point20'][0], all_points['point20'][1])

    if finger_first_angle > finger_first_angle_bend_threshold:  # 判断大拇指是否弯曲
        first_is_bend = True
        first_is_straighten = False
    else:
        first_is_bend = False
        first_is_straighten = True

    if finger_sencond_angle > finger_other_angle_bend_threshold:  # 判断食指是否弯曲
        second_is_bend = True
    elif finger_sencond_angle < finger_other_angle_straighten_threshold:
        second_is_straighten = True
    else:
        second_is_bend = False
        second_is_straighten = False

    if finger_third_angle > finger_other_angle_bend_threshold:  # 判断中指是否弯曲
        third_is_bend = True
    elif finger_third_angle < finger_other_angle_straighten_threshold:
        third_is_straighten = True
    else:
        third_is_bend = False
        third_is_straighten = False

    if finger_fourth_angle > finger_other_angle_bend_threshold:  # 判断无名指是否弯曲
        fourth_is_bend = True
    elif finger_fourth_angle < finger_other_angle_straighten_threshold:
        fourth_is_straighten = True
    else:
        fourth_is_bend = False
        fourth_is_straighten = False

    if finger_fifth_angle > finger_other_angle_bend_threshold:  # 判断小拇指是否弯曲
        fifth_is_bend = True
    elif finger_fifth_angle < finger_other_angle_straighten_threshold:
        fifth_is_straighten = True
    else:
        fifth_is_bend = False
        fifth_is_straighten = False

    # 将手指的弯曲或伸直状态存在字典中，简化后续函数的参数
    bend_states = {'first': first_is_bend, 'second': second_is_bend, 'third': third_is_bend, 'fourth': fourth_is_bend, 'fifth': fifth_is_bend}
    straighten_states = {'first': first_is_straighten, 'second': second_is_straighten, 'third': third_is_straighten, 'fourth': fourth_is_straighten, 'fifth': fifth_is_straighten}

    return bend_states, straighten_states

# 判断是否为 OK 手势
def judge_OK():
    # 食指弯曲，中指和无名指和小拇指笔直
    if bend_states['second'] and straighten_states['third'] and straighten_states['fourth'] and straighten_states['fifth']:
        distance4_and_8 = points_distance(all_points['point4'][0], all_points['point4'][1], all_points['point8'][0], all_points['point8'][1])
        distance2_and_6 = points_distance(all_points['point2'][0], all_points['point2'][1], all_points['point6'][0], all_points['point6'][1])
        # 节点4和节点8距离很小，也就是大拇指和食指之间的距离很小
        if distance4_and_8 < distance2_and_6:
            return 'OK'
        else:
            return False
    else:
        return False

# 判断是否为 return 手势
def judge_Return():
    # 五个手指都是弯曲的
    if bend_states['first'] and bend_states['second'] and bend_states['third'] and bend_states['fourth'] and bend_states['fifth']:
        # 保证手指在弯曲状态前提下还处于攥紧状态
        angle18_6_and_18_18_ = compute_angle(all_points['point18'][0], all_points['point18'][1], all_points['point6'][0], all_points['point6'][1],
                                             all_points['point18'][0], all_points['point18'][1], all_points['point18'][0] + 10, all_points['point18'][1])
        angle_6_18_and_6_6_ = compute_angle(all_points['point6'][0], all_points['point6'][1], all_points['point18'][0], all_points['point18'][1],
                                            all_points['point6'][0], all_points['point6'][1], all_points['point6'][0] + 10, all_points['point6'][1])
        angle_0_2_and_0_17 = compute_angle(all_points['point0'][0], all_points['point0'][1], all_points['point2'][0], all_points['point2'][1],
                                           all_points['point0'][0], all_points['point0'][1], all_points['point17'][0], all_points['point17'][1])
        if angle18_6_and_18_18_ < 0.1 * math.pi or angle_6_18_and_6_6_ < 0.1 * math.pi and angle_0_2_and_0_17 > 0.15 * math.pi:
            return 'Return'
        else:
            return False
    else:
        return False

# 判断是否为 Left 手势
def judge_Left_Right():
    angle0_0_and_0_4 = compute_angle(all_points['point0'][0], all_points['point0'][1], all_points['point0'][0] + 10, all_points['point0'][1],
                                      all_points['point0'][0], all_points['point0'][1], all_points['point4'][0], all_points['point4'][1])
    # 大拇指伸直，其他手指弯曲，并且大拇指保持水平
    if straighten_states['first'] and bend_states['second'] and bend_states['third'] and bend_states['fourth'] and bend_states['fifth']:
        # 向左向左大拇指关节点的坐标关系不同
        if angle0_0_and_0_4 > 0.7 * math.pi and all_points['point3'][0] < all_points['point2'][0]:
            return 'Left'
        elif angle0_0_and_0_4 < 0.25 * math.pi and all_points['point3'][0] > all_points['point2'][0]:
            return 'Right'
    else:
        return False

# 判断是否为 Like 手势
def judge_Like():
    # 大拇指伸直，其他手指弯曲，并且大拇指朝上
    if straighten_states['first'] and bend_states['second'] and bend_states['third'] and bend_states['fourth'] and bend_states['fifth']:
        angle0_0__and_0_4 = compute_angle(all_points['point0'][0], all_points['point0'][1], all_points['point0'][0] + 10, all_points['point0'][1],
                                          all_points['point0'][0], all_points['point0'][1], all_points['point4'][0], all_points['point4'][1])
        if angle0_0__and_0_4 > 0.25 * math.pi:
            return 'Like'
        else:
            return False
    else:
        return False

# 判断是否为 Pause 手势
def judge_Pause():
    # 这里大拇指笔直的判定有些问题，没有加进来
    if straighten_states['second'] and straighten_states['third'] and straighten_states['fourth'] and straighten_states['fifth']:
        angle0_2_and_0_17 = compute_angle(all_points['point0'][0], all_points['point0'][1], all_points['point2'][0], all_points['point2'][1],
                                          all_points['point0'][0], all_points['point0'][1], all_points['point17'][0], all_points['point17'][1])
        # 手掌垂直于水平面并且手指并拢
        if angle0_2_and_0_17 < 0.4 * math.pi and all_points['point3'][1] > all_points['point4'][1] and all_points['point6'][1] > all_points['point8'][1] and all_points['point10'][1] > all_points['point12'][1]:
            return 'Pause'
        else:
            return False
    else:
        return False


# 检测当前手势，返回当前手势
def detect_hand_state():
    state_OK = judge_OK()
    state_Return = judge_Return()
    state_Left_Right = judge_Left_Right()
    state_Like = judge_Like()
    state_Pause = judge_Pause()

    if state_OK == 'OK':
        return 'OK'
    elif state_Return == 'Return':
        return 'Return'
    elif state_Left_Right == 'Left':
        return 'Left'
    elif state_Left_Right == 'Right':
        return 'Right'
    elif state_Like == 'Like':
        return 'Like'
    elif state_Pause == 'Pause':
        return 'Pause'
    else:
        return 'None'

if __name__ == "__main__":
    # “Address Family Internet”，它是指定地址族为IPv4的标识符。
    # SOCK_DGRAM 指定了套接字的类型为数据报（datagram）套接字。数据报套接字是一种无连接的通信方式，它允许发送和接收消息，但并不保证消息的顺序或完整性。
    # 这种类型的套接字常用于UDP（User Datagram Protocol）协议。
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, 0)
    s.bind(("172.20.10.2", 9090))

    mp_drawing = mp.solutions.drawing_utils  # MediaPipe绘图工具
    mp_hands = mp.solutions.hands  # MediaPipe手势识别工具
    hands = mp_hands.Hands(
        static_image_mode=False,            # 默认为False，如果设置为false, 就是把输入看作一个视频流，在检测到手之后对手加了一个目标跟踪
        max_num_hands=1,                    # 可以检测到的手的数量最大值，默认是2
        min_detection_confidence=0.75,      # 手部检测的最小置信度值，大于这个数值被认为是成功的检测。默认为0.5
        min_tracking_confidence=0.5         # 目标踪模型的最小置信度值，大于这个数值将被视为已成功跟踪的手部，默认为0.5，如果static_image_mode设置为true，则忽略此操作。
    )

    recent_states = [''] * 10  # 存储最近 10 次的手势判断结果
    prev_time = 0
    last_printed_state = None  # 用于存储上一次打印的手势状态

    while True:
        # 接收数据
        data, addr = s.recvfrom(65535)  # 65535是UDP包的最大长度

        # 将字节数据（data）转换成一个NumPy数组。
        # dtype=np.uint8指定了数组元素的数据类型为无符号8位整数。
        frame = np.frombuffer(data, dtype=np.uint8)

        # 将NumPy数组（frame）解码成图像。
        # cv2.IMREAD_COLOR参数指定解码后的图像应该是彩色的。如果使用cv2.IMREAD_GRAYSCALE，则会得到灰度图像；使用cv2.IMREAD_UNCHANGED会保留图像的alpha通道。
        frame = cv2.imdecode(frame, cv2.IMREAD_COLOR)

        curr_time = time.time()  # 获取当前时间
        fps = 1 / (curr_time - prev_time) if prev_time != 0 else 0  # 计算帧率
        prev_time = curr_time  # 更新 prev_time

        # 将图像frame沿垂直轴（y轴）翻转。
        # 参数1表示沿x轴翻转图像，如果使用0则表示沿y轴翻转，-1表示沿两个轴翻转。
        frame = cv2.flip(frame, 1)

        # 获取图像frame的高度和宽度。
        h, w = frame.shape[:2]
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        # mediapipe库中手部追踪模块hands来处理图像image并检测手部关键点。
        keypoints = hands.process(image)

        if keypoints.multi_hand_landmarks:
            # multi_hand_landmarks是一个列表，其中包含了所有检测到的手势的关键点信息，每个手势是一个HandLandmark对象。
            lm = keypoints.multi_hand_landmarks[0]

            # 包含了手势关键点的枚举值，用于访问手势关键点的特定位置。
            lmHand = mp_hands.HandLandmark

            # landmark_list有 6 个子列表，分别存储着根节点坐标（0点）以及其它 5 根手指的关键点坐标
            landmark_list = [[] for _ in range(6)]

            for index, landmark in enumerate(lm.landmark):
                x = int(landmark.x * w)
                y = int(landmark.y * h)
                if index == lmHand.WRIST:
                    landmark_list[0].append((x, y))
                elif 1 <= index <= 4:
                    landmark_list[1].append((x, y))
                elif 5 <= index <= 8:
                    landmark_list[2].append((x, y))
                elif 9 <= index <= 12:
                    landmark_list[3].append((x, y))
                elif 13 <= index <= 16:
                    landmark_list[4].append((x, y))
                elif 17 <= index <= 20:
                    landmark_list[5].append((x, y))

            # 获取所有关节点的坐标
            point0 = landmark_list[0][0]
            point1, point2, point3, point4 = landmark_list[1][0], landmark_list[1][1], landmark_list[1][2], landmark_list[1][3]
            point5, point6, point7, point8 = landmark_list[2][0], landmark_list[2][1], landmark_list[2][2], landmark_list[2][3]
            point9, point10, point11, point12 = landmark_list[3][0], landmark_list[3][1], landmark_list[3][2], landmark_list[3][3]
            point13, point14, point15, point16 = landmark_list[4][0], landmark_list[4][1], landmark_list[4][2], landmark_list[4][3]
            point17, point18, point19, point20 = landmark_list[5][0], landmark_list[5][1], landmark_list[5][2], landmark_list[5][3]

            # 将所有关键点的坐标存储到一起，简化后续函数的参数
            all_points = {'point0': landmark_list[0][0],
                          'point1': landmark_list[1][0], 'point2': landmark_list[1][1], 'point3': landmark_list[1][2], 'point4': landmark_list[1][3],
                          'point5': landmark_list[2][0], 'point6': landmark_list[2][1], 'point7': landmark_list[2][2], 'point8': landmark_list[2][3],
                          'point9': landmark_list[3][0], 'point10': landmark_list[3][1], 'point11': landmark_list[3][2], 'point12': landmark_list[3][3],
                          'point13': landmark_list[4][0], 'point14': landmark_list[4][1], 'point15': landmark_list[4][2], 'point16': landmark_list[4][3],
                          'point17': landmark_list[5][0], 'point18': landmark_list[5][1], 'point19': landmark_list[5][2], 'point20': landmark_list[5][3]}

            # 调用函数，判断每根手指的弯曲或伸直状态
            bend_states, straighten_states = detect_all_finger_state()

            # 调用函数，检测当前手势
            current_state = detect_hand_state()

            # 更新最近状态列表
            recent_states.pop(0)
            recent_states.append(current_state)

            # 检查列表中的所有状态是否相同
            if len(set(recent_states)) == 1 and current_state != "None":  # 如果连续10帧的手势状态都相同且不是None，则认为手势稳定
                if current_state != last_printed_state:  # 只在手势变化时打印
                    print("Detected hand state:", current_state)
                    last_printed_state = current_state

            # 在画面上绘制帧率和手势
            cv2.putText(frame, f"FPS: {int(fps):.2f}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)
            if current_state != "None":
                cv2.putText(frame, current_state, (10, 70), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2, cv2.LINE_AA)

        cv2.imshow("Hand Detection", frame)
        if cv2.waitKey(1) == ord("q"):
            break
    cv2.destroyAllWindows()
