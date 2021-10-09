/*
* jQuery simple rater
*
* Copyright (c) 2008 Yılmaz Uğurlu, <yilugurlu@gmail.com>, http://www.2nci.com
* Licensed under the MIT License:
* http://www.opensource.org/licenses/mit-license.php
* 
* $Version: 1.0, 2008.11.15, rev. 29
*/

$(document).ready(function() {
	var ratingItems = $(".articleRating");

	for (var index = 0; index < ratingItems.length; index++) {
		var ratingArgs = $(ratingItems[index]).text();

		if (($("UL", ratingItems[index]).length > 0) && (typeof ($("UL", ratingItems[index]).attr('class').split('_')[1]) != 'undefined')) {
			var tempRate = $("UL", ratingItems[index]).attr('class').split('_')[1];
			ratingArgs = tempRate + "^^^^^";
		}

		$(ratingItems[index]).empty();

		var args = ratingArgs.split("^");

		var enabled = false;
		if (args[1] == "true") {
			enabled = true;
		}

		$(ratingItems[index]).rater({
			value: args[0],
			enabled: enabled,
			url: args[2],
			articleId: args[3],
			articleSectionId: args[4],
			ip: args[5],
			userId: args[6]
		});

	}
});

(function($) {
    $.fn.rater = function(options) {
        var defaults = {
            url: 'vote.php',
            enabled: true,
            favstar: false,
            favtitle: 'save as favorite',
            mediapath: '.',
            value: 0,
            articleId: 0,
            ip: '',
            articleSectionId: 0,
            indicator: true,
            callback: false,
            userId: 0
        };
        // işlem yapılan html elemanı
        var holder = $(this);
        // gelenle, varsayılanı birleştirelim
        var opts = $.extend(defaults, options);
        // problem çıkmaması için gelen parametreyi yuvarlayalım, düzenleyelim
        opts.value = Math.abs(Math.round(opts.value));
        opts.value = opts.value > 5 ? 5 : opts.value;
        var ratingui = ''; // içerik tutucu
        // yıldız biçimlendirmesi için css sınıfları
        var ratingcls = 'star_' + opts.value;
        // oy verme arayüzü için
        if (!opts.favstar) {
            ratingui += '<ul class="rating ' + ratingcls + '">';
            for (var i = 1; i <= 5; i++) {
                if (opts.enabled) {
                    ratingui += '<li class="s_' + i + '"><a href="#" title="' + i + '">' + i + '</a></li>';
                }
                else {
                    ratingui += '<li class="s_' + i + '"><span>' + i + '</span></li>';
                }
            }
        }
        else // favorilere ekleme arayüzü için
        {
            ratingui += '<ul class="fav ' + ratingcls + '"><li class="s_1">';
            if (opts.enabled) {
                ratingui += '<a href="#" title="' + opts.favtitle + '">' + (opts.value == 1 ? 0 : 1) + '</a></li>';
            }
            else {
                ratingui += '<span>' + (opts.value == 1 ? 0 : 1) + '</span></li>';
            }
        }
        // indicator gösterilmek isteniyorsa
        if (opts.indicator && !opts.favstar) {
            ratingui += '<li class="indicator"></li>';
        }

        ratingui += '</ul>';
        // oluşturulan arayüzü html içerisine gömelim    
        holder.html(ratingui);
        // yükleniyor animasyonunu gösterecek html elemanı
        var indicator = holder.find('ul > li.indicator');
        // yıldızlardan birine tıklandığında
        holder.find('ul > li > a').click(function() {
            var value = $(this).html();
            // eğer bir callback fonksiyon atanmış ise
            if (opts.callback != false) {
                opts.callback(value);
                return false;
            }
            // yükleniyor içeriği
            if (opts.indicator && !opts.favstar) {
                indicator.show();
            }

            $.ajax({
                type: "POST",
                url: opts.url,
                data: "{'rating':'" + value + "','articleId':'" + opts.articleId + "','articleSectionId':'" + opts.articleSectionId + "','ip':'" + opts.ip + "','userId':'" + opts.userId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(msg) {
                    if (opts.indicator && !opts.favstar) {
                        indicator.hide();
                    }

                    value = msg.d;

                    document.cookie = set_cookie("cookie_articleId", opts.articleId + '^' + opts.articleSectionId);

                    // tıkladığımız yıldızın uzunuluğunu css sınıfları içerisinden seçelim
                    var newcls = 'star_' + value;
                    holder.find('ul').removeClass(ratingcls).addClass(newcls);
                    ratingcls = newcls;
                    // eğer favorilere ekleme yıldızı değilse, tüm elemanları devre dışı bırakalım
                    if (!opts.favstar) {
                        $(holder.find('ul > li')).each(function(i) {
                            if ($(this).attr('class') != 'indicator') // if element is not indicator
                            {
                                $(this).html('<span>' + i + '</span>');
                            }
                        });
                    }
                    else {
                        $(this).html(value == 1 ? '0' : '1');
                    }
                }
            });

            return false;
        });

        return this;
    };
})(jQuery);

function get_cookie(cookie_name) {
    var results = document.cookie.match('(^|;) ?' + cookie_name + '=([^;]*)(;|$)');

    if (results) {
        return results[2];
    }
    else {
        return null;
    }
}

function set_cookie(name, value) {
    var oldValue = get_cookie(name);
    if (oldValue != null) {
        value = oldValue + "," + value;
    }
    var DateNow = new Date();
    DateNow.setFullYear(DateNow.getFullYear() + 3000);
    var cookie_string = name + "=" + value + "; expires=" + DateNow.toGMTString();

    document.cookie = cookie_string;
}