<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserRemarks.aspx.cs" Inherits="Design_IPD_UserRemarks" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="../../Scripts/Message.js"   type ="text/javascript"></script>
    <script type="text/javascript" >
        $(document).ready(function () {
            var MaxLength = 300;
            $("#<% =txtRemarks.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtRemarks.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });
        });
        var characterLimit = 300;
        $(document).ready(function () {
            $("#lblremaingCharacters").html(characterLimit);
            $("#<%=txtRemarks.ClientID %>").bind("keyup", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > characterLimit) {
                    $(this).val($(this).val().substr(0, characterLimit));
                }
                var characterRemaining = characterLimit - characterInserted;
                $("#lblremaingCharacters").html(characterRemaining);
            });
        });
        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if ($(id).length > charlimit) {
                $(id).text($(id).text().substring(0, charlimit));
                $("#divmessage").html("Maximum text length allowed is :" + charlimit);
            }
            else
                $("#divmessage").html("");
        }
        function userRemarks() {
            if ($("#<%=txtRemarks.ClientID %>").val() == '') {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Remarks');
                $("#<%=txtRemarks.ClientID %>").focus();
                return false;
            }

            else {
                $("#<%=lblMsg.ClientID %>").text('');

            }
            $.ajax({
                url: "Services/IPD.asmx/IPDUserRemarks",
                data: '{TID:"' + $("#lblTID").text() + '",userRemarks:"' + $("#<%=txtRemarks.ClientID %>").val() + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        $("#lblMsg").text('Record Saved Successfully');
                        $('#txtRemarks').val('');
                        bindUserRemarks();
                    }
                    else {
                        $("#lblMsg").text('');
                    }
                }

            });
        }
        $(function () {
            bindUserRemarks();
        });
        function bindUserRemarks() {
            $('#UserRemarks').html('');
            $.ajax({
                url: "Services/IPD.asmx/bindIPDUserRemarks",
                data: '{TID:"' + $("#lblTID").text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == null || (result.d == "")) {
                                                return;
                    }
                    else
                        $('#UserRemarks').append(CreateTableView(result.d, 'GridViewStyle', true));

                    
                },
                error: function (xhr, status) {
                    return false;
                }
            });
        }
        function CreateTableView(objArray, theme, enableHeader) {
            if (theme === undefined) {
                theme = 'mediumTable'; 
            }

            if (enableHeader === undefined) {
                enableHeader = true; 
            }

            var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
            var str = '<table class="GridViewStyle" style="width:100%;text-align:center" >';
            if (enableHeader) {
                str += '<thead><tr>';
                for (var index in array[0]) {
                    str += '<th class="GridViewHeaderStyle" scope="col">' + index + '</th>';
                }
                str += '</tr></thead>';
            }

            // table body
            str += '<tbody>';
            for (var i = 0; i < array.length; i++) {
                str += (i % 2 == 0) ? '<tr class="alt">' : '<tr>';
                for (var index in array[i]) {
                    str += '<td class="GridViewItemStyle" style="text-align:center">' + array[i][index] + '</td>';
                }
                str += '</tr>';
            }
            str += '</tbody>'
            str += '</table>';
            return str;
        }

    </script>

    <form id="form1" runat="server">
       <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>User Remarks</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                User Remarks
            </div>
           
        </div>
               <div class="POuter_Box_Inventory" style="text-align: center">

            <table style="width: 100%" >
                <tr>
                    <td style="width: 15%; text-align: right;" >
                        User Remarks :
                    </td>
                    <td colspan="3" style="text-align:left" >
                        <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Height="94px" Width="497px"
                            Style="margin-left: 0px" onkeyup="javascript:ValidateCharactercount(300,this);" TabIndex="1" ToolTip="Enter Billing Remarks"></asp:TextBox>
                        <asp:Label ID="lblV1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <asp:RequiredFieldValidator ID="reqRemarks" runat="server" Display="None" ErrorMessage="Please Enter Billing Remarks"
                            ControlToValidate="txtRemarks" ValidationGroup="save"></asp:RequiredFieldValidator>
                        Number of Characters Left:
                        <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                        </label>
                        <br />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div id="divmessage" style="color: Red;">
                        </div>
                    </td>
                </tr>
            </table>
       </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" class="ItDoseButton" id="btnSave" onclick="userRemarks()" value="Save"  title="Click to Save"/>
                   </div>
           <asp:Label ID="lblTID" runat="server" style="display:none"  ClientIDMode="Static"></asp:Label>
        <div class="POuter_Box_Inventory" style="text-align:center;">
            
          
                 <table id="UserRemarks" style="width:100%;text-align:center" ></table>
               
            </div>
    </div>

    </form>
</body>
</html>
