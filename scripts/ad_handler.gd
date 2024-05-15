extends Node
class_name Ad_Handler


var banner_id : String = "ca-app-pub-3940256099942544/6300978111"

var _ad_view : AdView

func _ready() -> void:
	MobileAds.initialize()
	print('MobileAds initialized')

func load_banner_ad() -> void:
	if _ad_view == null:
		_create_ad_view()
	var ad_request := AdRequest.new()
	_ad_view.load_ad(ad_request)
	print('loading banner ad')

func _create_ad_view() -> void:
	if _ad_view:
		destroy_ad_view()

	var adaptive_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	_ad_view = AdView.new(banner_id, adaptive_size, AdPosition.Values.BOTTOM)
	print('created ad view')


func register_ad_listener() -> void:
	if _ad_view != null:
		var ad_listener := AdListener.new()

		ad_listener.on_ad_failed_to_load = func(load_ad_error : LoadAdError) -> void:
			print("_on_ad_failed_to_load: " + load_ad_error.message)
		ad_listener.on_ad_clicked = func() -> void:
			print("_on_ad_clicked")
		ad_listener.on_ad_closed = func() -> void:
			print("_on_ad_closed")
		ad_listener.on_ad_impression = func() -> void:
			print("_on_ad_impression")
		ad_listener.on_ad_loaded = func() -> void:
			print("_on_ad_loaded")
		ad_listener.on_ad_opened = func() -> void:
			print("_on_ad_opened")

		_ad_view.ad_listener = ad_listener

func destroy_ad_view() -> void:
	if _ad_view:
		#always call this method on all AdFormats to free memory on Android/iOS
		_ad_view.destroy()
		_ad_view = null