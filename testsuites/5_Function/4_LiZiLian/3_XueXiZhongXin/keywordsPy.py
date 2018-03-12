#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random
import time
import string
import os


"""
Creat fake datas for Add goods table
"""

class keywordsPy(object):

    ROBOT_LIBRARY_VERSION = 1.0

    def __init__(self):
        pass

    def fake_goodname(self,basename):
        return basename + time.strftime("%H%M%S", time.localtime())

    def fake_price(self):
        return time.strftime("%M%S", time.localtime())

    def fake_brand(self,goodClass):
        if "设备类" in goodClass:
            modeList = "圣象 德尔Der 大自然 升达 菲林格尔 安信 卡尔玛 永吉地板 久盛 生活家".split(' ')
            return random.choice(modeList)
        elif "耗材类" in goodClass:
            modeList = "李宁 安踏 匹克 361° 特步 沃特 乔丹  康威".split(' ')
            return random.choice(modeList)
        elif "场地类" in goodClass:
            modeList = "普罗旺斯 香榭丽舍 枫丹白露  埃菲尔铁塔 意大利：法彼雅诺 西西里 米兰 瑞士：日内瓦 琉森 苏黎世 阿尔卑斯 洛伊克巴德 洛桑 悉尼 都柏林 维也纳 香格里拉（中） 堪培拉（澳大利亚） 爱丁堡（英） 直布罗陀 梵蒂冈".split(' ')
            return random.choice(modeList)
        elif "服务类" in goodClass:
            modeList = " 周大福 六福 金至尊 周生生 周大生 戴梦得 越王 福辉 谢瑞麟 老凤祥".split(' ')
            return random.choice(modeList)
        else:
            modeList = "红旗 华利 皇冠 霍顿 佳美 捷达 雷诺 林肯 凌志 铃木 罗孚 美日 尼桑 欧宝 奇瑞 起亚 三菱 绅宝 拉达".split(' ')
            return random.choice(modeList)

    def fake_goodNo(self,goodClass):
        if "设备类" in goodClass:
            return random.choice(['01',])+"".join(random.choice("0123456789") for i in range(5))
        elif "耗材类" in goodClass:
            return random.choice(['02',])+"".join(random.choice("0123456789") for i in range(5))
        elif "场地类" in goodClass:
            return random.choice(['03',])+"".join(random.choice("0123456789") for i in range(5))
        elif "服务类" in goodClass:
            return random.choice(['04',])+"".join(random.choice("0123456789") for i in range(5))
        else:
            return random.choice(['01',])+"".join(random.choice("0123456789") for i in range(5))

    def fake_unitName(self,goodClass):
        if "设备类" in goodClass:
            modeList = "台 件".split(' ')
            return random.choice(modeList)
        elif "耗材类" in goodClass:
            modeList = "双  只".split(' ')
            return random.choice(modeList)
        elif "场地类" in goodClass:
            modeList = "千米 光年".split(' ')
            return random.choice(modeList)
        elif "服务类" in goodClass:
            modeList = "万 时".split(' ')
            return random.choice(modeList)
        else:
            modeList = "个 双 组 台 页 块 分 时 刻 人 组".split(' ')
            return random.choice(modeList)
        
    def fake_unitSize(self,goodClass):
        if "设备类" in goodClass:
            modeList = "台 件 组 套 系列".split(' ')
            return random.choice(modeList)
        elif "耗材类" in goodClass:
            modeList = "个人  企业".split(' ')
            return random.choice(modeList)
        elif "场地类" in goodClass:
            modeList = "个人 团队".split(' ')
            return random.choice(modeList)
        elif "服务类" in goodClass:
            modeList = "私人  公共  企业  社会  政府".split(' ')
            return random.choice(modeList)
        else:
            modeList = "个 双 组 台 页 块 分 时 刻 人 组".split(' ')
            return random.choice(modeList)
        
    def fake_unitAccount(self,goodClass):
        if "设备类" in goodClass:
            return random.choice(['SB',])+"".join(random.choice("0123456789") for i in range(5))
        elif "耗材类" in goodClass:
            return random.choice(['HC',])+"".join(random.choice("0123456789") for i in range(5))
        elif "场地类" in goodClass:
            return random.choice(['CD',])+"".join(random.choice("0123456789") for i in range(5))
        elif "服务类" in goodClass:
            return random.choice(['FW',])+"".join(random.choice("0123456789") for i in range(5))
        else:
            return random.choice(['PJ',])+"".join(random.choice("0123456789") for i in range(5))

    def fake_goodModel(self):
        return 'NO' + ''.join(random.choice(string.digits) for n in range(6))

    def fake_identification(self,size=18):
        return ''.join(random.choice(string.digits) for n in range(size))


    def fake_alias(self,basename,index):
        return basename + str(index)

    def correct_type(self,item):
        if isinstance(item, int):
            return str(item)

    def new_index_list(self,count):
        return [x for x in range(int(count))]

    def get_index_real_data(self,data):
        return str(data)

    def fake_goods(self,goodsName,goodClass,data_file_name = "fake_goods.csv"):
        tmp_account = {}
        tmp_account['goodsName'] = self.fake_goodname(goodsName)
        tmp_account['goodsNo'] = self.fake_goodNo(goodClass)
        tmp_account['price'] = self.fake_price()
        tmp_account['brand'] = self.fake_brand(goodClass)
        tmp_account['unitName'] = self.fake_unitName(goodClass)
        tmp_account['goodModel'] = self.fake_goodModel()
        tmp_account['size'] = self.fake_unitSize(goodClass)
        tmp_account['account'] = self.fake_unitAccount(goodClass)
        print(tmp_account)
        with open(os.path.join(os.path.abspath(r"testsuites/4_LiZiLian/1_ZiYuanShangCheng/Data/"),data_file_name),'a') as fd:
            fd.write(tmp_account['goodsName'] + ',' + tmp_account['goodsNo'] + ',' + tmp_account['price'] + ',' + tmp_account['brand'] + ',' + tmp_account['unitName'] + ',' + tmp_account['goodModel'] + "\n")
        return tmp_account

if __name__ == "__main__":
    fc = keywordsPy()
    #===========================================================================
    # goodsName = "xtcAuto"
    # goodClass = "设备类"
    # index = 14
    # fc.fake_goods(goodsName,goodClass,data_file_name = "fake_goods.csv")
    #===========================================================================
