<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CountSheet.aspx.cs" Inherits="Design_OT_Post_CountSheet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script lang="javascript" src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("table[id*=grdDetail] input[type=text][id*=txtinitial]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() == "0")  || ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtinitial]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtinitial]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtinitial]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());

                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());

                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                    }


                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());

                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                }
                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtaddInitial1]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() == "0")  || ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtaddInitial1]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtaddInitial1]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);

                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtaddInitial2]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() == "0")  || ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtaddInitial2]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtaddInitial2]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                    }


                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtaddInitial3]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() == "0")  || ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtaddInitial3]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtaddInitial3]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                    }


                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtaddInitial4]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() == "0")  || ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtaddInitial4]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtaddInitial4]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                    }


                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtaddInitial5]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() == "0")  || ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtaddInitial5]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtaddInitial5]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                    }


                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
        });

        $(document).ready(function () {
            $("table[id*=grdDetail] input[type=text][id*=txtFirst]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtFirst]").val() == "0") || ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtFirst]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtFirst]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtFirst]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                    }
                    if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                    }

                    var final = parseFloat(total + price5);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtTotal2]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                }
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                }

                var final = parseFloat(total + price5);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtTotal2]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtFistAdd1]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() == "0")|| ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtFistAdd1]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtFistAdd1]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                    }
                    if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                    }

                    var final = parseFloat(total + price5);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtTotal2]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                }
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                }

                var final = parseFloat(total + price5);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtTotal2]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);
            });
            $("table[id*=grdDetail] input[type=text][id*=txtFistAdd2]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() == "0")  || ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtFistAdd2]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtFistAdd2]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                    }
                    if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                    }

                    var final = parseFloat(total + price5);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtTotal2]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                }
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                }

                var final = parseFloat(total + price5);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtTotal2]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);
            });

            $("table[id*=grdDetail] input[type=text][id*=txtFistAdd3]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() == "0")  || ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtFistAdd3]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtFistAdd3]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                    }
                    if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                    }

                    var final = parseFloat(total + price5);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtTotal2]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                }
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                }

                var final = parseFloat(total + price5);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtTotal2]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);
            });

            $("table[id*=grdDetail] input[type=text][id*=txtFistAdd4]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() == "0")  || ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtFistAdd4]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtFistAdd4]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    alert(q);
                    if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                    }
                    if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                    }

                    var final = parseFloat(total + price5);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtTotal2]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                }
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                }

                var final = parseFloat(total + price5);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtTotal2]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);
            });
            $("table[id*=grdDetail] input[type=text][id*=txtSecond]").blur(function () {
                var price1 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() == "0") || ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtSecond]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtSecond]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtSecond]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtTotal2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtTotal2]").val() != "") && ($(this).closest("tr").find("input[id*=txtTotal2]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtTotal2]").val());
                    }
                    var final = parseFloat(total + price1);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(price1);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtFinal]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtTotal2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtTotal2]").val() != "") && ($(this).closest("tr").find("input[id*=txtTotal2]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtTotal2]").val());
                }
                var final = parseFloat(price1 + q);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(price1);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtFinal]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;
                });
                total = total.toFixed(2);
            });


            $("#grdDetail tr").each(function () {
                var checkBox = $(this).find("input[type='checkbox']");
                if ($(checkBox).is(':checked')) {
                    $(this).attr("checked", "checked");
                    var td = $("td", $(this).closest("tr"));
                    $("input[type=text]", td).removeAttr("disabled");
                } else {
                    $(this).removeAttr("checked");
                    var td = $("td", $(this).closest("tr"));
                    $("input[type=text]", td).attr("disabled", "disabled");
                }
            
            });

            $('#<%=grdDetail.ClientID %>').find('input:checkbox[id$="chkAll"]').click(function () {
                var isChecked = $(this).prop("checked");
                $("#<%=grdDetail.ClientID %> [id*=chkSelect]:checkbox").prop('checked', isChecked);
            });


            $("[id*=chk]").live("click", function () {
                var grid = $(this).closest("table");
                var chkHeader = $("[id*=chkAll]", grid);
                if (!$(this).is(":checked")) {
                    var td = $("td", $(this).closest("tr"));
                    td.css({ "background-color": "FFF" });
                    chkHeader.removeAttr("checked");
                    $("input[type=text]", td).attr("disabled", "disabled");
                  } else {
                    var td = $("td", $(this).closest("tr"));
                    td.css({ "background-color": "A1DCF2" });
                    $("input[type=text]", td).removeAttr("disabled");
                    if ($("[id*=chk]", grid).length == $("[id*=chk]:checked", grid).length)
                        chkHeader.attr("checked", "checked");
                }

            });
            function checkAll(objRef) {
                var GridView = objRef.parentNode.parentNode.parentNode;
                var inputList = GridView.getElementsByTagName("input");
                for (var i = 0; i < inputList.length; i++) {
                    var row = inputList[i].parentNode.parentNode;
                    if (inputList[i].type == "checkbox" && objRef != inputList[i]) {
                        if (objRef.checked) {
                            inputList[i].checked = true;
                        }
                        else {
                            inputList[i].checked = false;
                        }
                    }
                }
            }
        });

    </script>
      <script type="text/javascript">
          function Check_Click(objRef) {
              var row = objRef.parentNode.parentNode;
              var GridView = row.parentNode;
              var inputList = GridView.getElementsByTagName("input");
              for (var i = 0; i < inputList.length; i++) {
                  var headerCheckBox = inputList[0];
                  var checked = true;
                  if (inputList[i].type == "checkbox" && inputList[i] != headerCheckBox) {
                      if (!inputList[i].checked) {
                          checked = false;
                          break;
                      }
                  }
              }
              headerCheckBox.checked = checked;
          }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory" style="margin-top:0px;">
            <div class="POuter_Box_Inventory" >
                <div  style="text-align: center;">
                    <b>Count Sheet</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
            <div id="tableHeader"></div>
            <div class="POuter_Box_Inventory" style="overflow: scroll; height: 400px;">
                <asp:GridView ID="grdDetail" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdDetail_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                             <asp:TemplateField>
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkAll" runat="server" onclick="checkAll(this);"></asp:CheckBox>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chk" runat="server" onclick="Check_Click(this)"></asp:CheckBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Surgeon">
                            <ItemTemplate>
                                 <asp:TextBox ID="txtSurgeon" runat="server" Text='<%#Eval("Surgeon") %>' Width="90px"></asp:TextBox>
                                <asp:Label ID="lblSurgeon" runat="server" Text='<%#Eval("Surgeon") %>'></asp:Label>
                                <asp:Label ID="lblSurgeonID" runat="server" Text='<%#Eval("SurgeonID") %>' Visible="false"></asp:Label>
                                   <asp:Label ID="lblSurgeonMaster" runat="server" Text='<%#Eval("Surgeonmaster") %>' Visible="false"></asp:Label>

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Initial">
                            <ItemTemplate>
                                <asp:TextBox ID="txtinitial" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("initial") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fltinitial" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtinitial" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Additional">
                            <ItemTemplate>
                                <asp:TextBox ID="txtaddInitial1" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("addInitial1") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fltinitial1" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtaddInitial1" />
                                
                                 <asp:TextBox ID="txtaddInitial2" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("addInitial2") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtaddInitial2" />
                                
                                
                                <asp:TextBox ID="txtaddInitial3" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("addInitial3") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtaddInitial3" />
                             
                                
                                
                                <asp:TextBox ID="txtaddInitial4" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("addInitial4") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtaddInitial4" />
                                
                                
                                
                                <asp:TextBox ID="txtaddInitial5" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("addInitial5") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtaddInitial5" />
                              
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total">
                            <ItemTemplate>                            
                                <asp:TextBox ID="txttotal1" runat="server" Text='<%#Eval("Total1") %>' Width="50px"></asp:TextBox>

                                <cc1:FilteredTextBoxExtender ID="flttxttotal1" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txttotal1" />
                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="First">
                            <ItemTemplate>
                                <asp:TextBox ID="txtFirst" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("CountFirst") %>' AutoCompleteType="Disabled"></asp:TextBox>
                               <cc1:FilteredTextBoxExtender ID="fltFirst" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFirst" />
                              
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Additional">
                            <ItemTemplate>
                                <asp:TextBox ID="txtFistAdd1" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("FistAdd1") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="flttxtFistAdd1" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFistAdd1" />
                              

                                <asp:TextBox ID="txtFistAdd2" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("FistAdd2") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFistAdd2" />
                             

                                <asp:TextBox ID="txtFistAdd3" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("FistAdd3") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFistAdd3" />
                            


                                <asp:TextBox ID="txtFistAdd4" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("FistAdd4") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFistAdd4" />
                               
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total">
                            <ItemTemplate>
                                <asp:TextBox ID="txtTotal2" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("Total2") %>' AutoCompleteType="Disabled"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Second">
                            <ItemTemplate>
                                <asp:TextBox ID="txtSecond" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("CountSecond") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                  <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtSecond" />
                              
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Final">
                            <ItemTemplate>
                                <asp:TextBox ID="txtFinal" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("Final") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                  <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFinal" />
                              
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click"/>
                    &nbsp;<asp:Button ID="btnPrint" CssClass="ItDoseButton" runat="server" TabIndex="79"
                        Text="Print" Visible="false" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
