extends Node

var widx = [0, 1, 2, 3, 45, 48, 51, 53, 55, 61, 63, 65, 71, 73, 75, 95, 96, 99]

var wmo_weather_codes = [
	{
	  "code": 0,
	  "description": "Klarer Himmel",
	  "filename": "res://assets/weather/clear-day.svg",
	  "background": "res://assets/bg/bg9.png"
	},
	{
	  "code": 1,
	  "description": "Hauptsächlich klar",
	  "filename": "res://assets/weather/mostly-clear-day.svg",
	  "background": "res://assets/bg/bg11.png"
	},
	{
	  "code": 2,
	  "description": "Teilweise bewölkt",
	  "filename": "res://assets/weather/partly-cloudy-day.svg",
	  "background": "res://assets/bg/bg10.png"
	},
	{
	  "code": 3,
	  "description": "Bewölkt",
	  "filename": "res://assets/weather/cloudy.svg",
	  "background": "res://assets/bg/bg36.png"
	},
	{
	  "code": 45,
	  "description": "Nebel mit Reif",
	  "filename": "res://assets/weather/fog.svg",
	  "background": "res://assets/bg/bg35.png"
	},
	{
	  "code": 48,
	  "description": "Nebel ohne Reif",
	  "filename": "res://assets/weather/fog.svg",
	  "background": "res://assets/bg/bg25.png"
	},
	{
	  "code": 51,
	  "description": "Leichter Nieselregen",
	  "filename": "res://assets/weather/rain.svg",
	  "background": "res://assets/bg/bg26.png"
	},
	{
	  "code": 53,
	  "description": "Mäßiger Nieselregen",
	  "filename": "res://assets/weather/rain.svg",
	  "background": "res://assets/bg/bg40.png"
	},
	{
	  "code": 55,
	  "description": "Starker Nieselregen",
	  "filename": "res://assets/weather/rain.svg",
	  "background": "res://assets/bg/bg39.png"
	},
	{
	  "code": 61,
	  "description": "Leichter Regen",
	  "filename": "res://assets/weather/rain.svg",
	  "background": "res://assets/bg/bg37.png"
	},
	{
	  "code": 63,
	  "description": "Mäßiger Regen",
	  "filename": "res://assets/weather/rain.svg",
	  "background": "res://assets/bg/bg40.png"
	},
	{
	  "code": 65,
	  "description": "Starker Regen",
	  "filename": "res://assets/weather/raindrop.svg",
	  "background": "res://assets/bg/bg40.png"
	},
	{
	  "code": 71,
	  "description": "Leichter Schneefall",
	  "filename": "res://assets/weather/snow.svg",
	  "background": "res://assets/bg/bg6.png"
	},
	{
	  "code": 73,
	  "description": "Mäßiger Schneefall",
	  "filename": "res://assets/weather/snow2.svg",
	  "background": "res://assets/bg/bg28.png"
	},
	{
	  "code": 75,
	  "description": "Starker Schneefall",
	  "filename": "res://assets/weather/snowflake2.svg",
	  "background": "res://assets/bg/bg13.png"
	},
	{
	  "code": 95,
	  "description": "Gewitter",
	  "filename": "res://assets/weather/thunderstorm.svg",
	  "background": "res://assets/bg/bg41.png"
	},
	{
	  "code": 96,
	  "description": "Gewitter mit leichtem Hagel",
	  "filename": "res://assets/weather/lightning.svg",
	  "background": "res://assets/bg/bg41.png"
	},
	{
	  "code": 99,
	  "description": "Gewitter mit starkem Hagel",
	  "filename": "res://assets/weather/hail.svg",
	  "background": "res://assets/bg/bg41.png"
	}
  ]
