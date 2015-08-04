// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require angular
//= require angular-animate
//= require angular-resource

var SELECTED_PURCHASES = [];

$(document).ready(function() {
    if (SELECTED_PURCHASES.length == 0) {
        $("#collect_button").attr("disabled", "disabled");
    }

    $("#add_button").attr("disabled", "disabled");

    $("#product, #amount").keyup(function() {
        var input = $(this).val();

        if (input.length > 0
            && ($("#amount").val() > 0 && $("#amount").val() < 1001)) {
            document.getElementById("add_button").disabled = false;
        } else {
            document.getElementById("add_button").disabled = true;
        }
    });
});

function purchase_collected(purchase_id) {
    $.ajax({url: "/purchase/toggle_bought",
        data: {id: purchase_id},
        success: function() {
            $("#purchase_id_" + purchase_id).remove();
        },
        type: "post"
    });
}

function collectSelectedPurchases() {
    $.ajax({url: "/purchases/toggle_bought",
        data: {ids: SELECTED_PURCHASES},
        success: function() {
            for (var i = 0; i < SELECTED_PURCHASES.length; i++) {
                $("#purchase_id_" + SELECTED_PURCHASES[i]).remove();
            }
            document.getElementById("collect_button").disabled = true;
            SELECTED_PURCHASES = [];
        },
        type: "post"
    });
}

function selectPurchase(id) {
    if (!($(document).find("#purchase_id_" + id).hasClass("selected"))) {
        $(document).find("#purchase_id_" + id).addClass("selected");
        SELECTED_PURCHASES.push(id);
        document.getElementById("collect_button").disabled = false;
    } else {
        $(document).find("#purchase_id_" + id).removeClass("selected");
        var i = SELECTED_PURCHASES.indexOf(id);
        SELECTED_PURCHASES.splice(i, 1);
        if (SELECTED_PURCHASES.length == 0) {
            document.getElementById("collect_button").disabled = true;
        }
    }
}

function addPurchase() {
    var product = document.getElementById('product').value;
    var list = document.getElementById('list').value;
    var amount = document.getElementById('amount').value;

    $.ajax({url: "/purchases",
        data: {
            product: product,
            list: list,
            amount: amount
        },
        dataType: "json",
        success: function(data) {
            var purchase_table = document.getElementById("purchase_table");
            var row = document.createElement("TR");
            var productTd = document.createElement("TD");
            var amountTd = document.createElement("TD");
            row.setAttribute("id", "purchase_id_" + data.id);
            row.setAttribute("class", "purchase_row");
            row.setAttribute("onclick", "selectPurchase(" + data.id + ")");
            productTd.textContent = data.product.name;
            amountTd.textContent = data.amount;

            row.appendChild(productTd);
            row.appendChild(amountTd);
            purchase_table.appendChild(row);

            document.getElementById('product').value = "";
            document.getElementById('amount').value = 1;
            document.getElementById("add_button").disabled = true;
        },
        error: function() {
            alert("Something went wrong!");
        },
        type: "post"
    });
}