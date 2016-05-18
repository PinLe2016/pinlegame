//
//  PinLe_ platform.hpp
//  pinlegame
//
//  Created by Kennedy on 16/5/16.
//
//

#ifndef PinLe_platform_hpp
#define PinLe_platform_hpp

#include <stdio.h>
#include "cocos2d.h"
using namespace std;
USING_NS_CC;
class PinLe_platform :public Ref
{
public:
    PinLe_platform();
    ~PinLe_platform();
    static  PinLe_platform* Instance();
    void    getLocation();
    
public:
    void  setProvince(string province){_province=province;};
    string getProvince(){return _province; };
    
    void  setCity(string city){_city=city;};
    string getCity(){return _city;};
    
    void setCounty(string county){_county=county;};
    string getCounty(){return _county; };
public:
    string _province;
    string _city;
    string _county;
};

#endif /* PinLe__platform_hpp */
