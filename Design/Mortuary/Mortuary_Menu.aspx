<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mortuary_Menu.aspx.cs" Inherits="Design_Mortuary_Mortuary_Menu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../Styles/PurchaseStyle.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $.ajax({
                url: "../Common/CommonService.asmx/LoadFrameMortuary",
                data: '{ RoleID:"' + $("#lblRoleID").text() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data != null && Data != "") {
                        for (var i = 0; i < Data.length; i++) {
                            $(".HeaderTab").append(' <a style="background-color:darkcyan;width:100%;" target="Contentframe" href=' + Data[i].URL + '?CorpseID=' + $("#lblCorpseID").text() + '&TransactionID=' + $("#lblTransactionID").text()+ '>' + Data[i].FileName + '</a>');

                        }
                    }
                },
                error: function (xhr, status) {
                    alert("Error occurred, Please contact administrator");
                    return false;
                }
            });
        });
        $(document).on("click", 'a', function () {
            $('a').removeClass('hover');
            $(this).addClass('hover').css('cursor', 'pointer');
        });
    </script>
    <style>
        .hover
        {
            border-top: 3px solid #f00;
            border-bottom: 3px solid #f00;
        }
    </style>
</head>
<body style="margin: 0; border-collapse: collapse;">
    <asp:Label ID="lblCorpseID" ClientIDMode="Static" Style="display: none" runat="server" />
    <asp:Label ID="lblTransactionID" ClientIDMode="Static" Style="display: none" runat="server" />
    <asp:Label ID="lblRoleID" ClientIDMode="Static" Style="display: none" runat="server" />
    <table style="border-color: inherit; width: 100%; border-width: medium; text-indent: 2pt; vertical-align: top; text-align: left;">
        <tr>
            <td style="width: 100%;height:27px;"></td>
        </tr>
        <tr>
            <td class="HeaderTab" style="width: 100%"></td>
        </tr>
    </table>
</body>
</html>
