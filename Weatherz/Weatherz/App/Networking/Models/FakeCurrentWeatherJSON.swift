import Foundation

struct FakeCurrentWeatherJSON {
    func build() -> String {
        return
"""
{
    "request": {
        "type": "City",
        "query": "Mother Brain Land, SR388",
        "language": "en",
        "unit": "m"
    },
    "location": {
        "name": "Mother Brain Land",
        "country": "SR388",
        "region": "Mother Brain Land",
        "lat": "40.585",
        "lon": "-105.084",
        "timezone_id": "America/Denver",
        "localtime": "2023-05-16 20:00",
        "localtime_epoch": 1684267200,
        "utc_offset": "-6.0"
    },
    "current": {
        "observation_time": "02:00 AM",
        "temperature": -19,
        "weather_code": 116,
        "weather_icons": [
            "https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png"
        ],
        "weather_descriptions": [
            "Partly cloudy"
        ],
        "wind_speed": 13,
        "wind_degree": 90,
        "wind_dir": "E",
        "pressure": 1019,
        "precip": 0,
        "humidity": 52,
        "cloudcover": 75,
        "feelslike": 19,
        "uv_index": 5,
        "visibility": 16,
        "is_day": "yes"
    }
}
"""
    }
}
