<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="SetItemDetail.aspx.cs" Inherits="Design_CSSD1_SetItemDetail" EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral,
 PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager ID="scripmanger" runat="server">
    </cc1:ToolkitScriptManager>
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(
               function () {
                   $("#btnSave").attr('style', 'display:none;');
                   $("#btnAdd").click(AddItem);
                   $("#btnSave").click(SaveData);
                   $("#btnSaveSet").click(SaveDataSet);
                   var options = $('#<% = lstitems.ClientID %> option');
               });
               function wopen(url, name, w, h) {
                   w += 32;
                   h += 96;
                   var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
                   win.resizeTo(w, h);
                   win.moveTo(10, 100);
                   win.focus();
               }
               function loadSets() {
                   var ddlSetItem = $("#<%=ddlSetItem.ClientID %>");
                   $.ajax({

                       url: "Services/StoreItems.asmx/BindSets",
                       data: '{}',
                       type: "POST",
                       contentType: "application/json; charset=utf-8",
                       timeout: 120000,
                       dataType: "json",
                       success: function (result) {
                           PatientData = jQuery.parseJSON(result.d);
                           $("#<%=ddlSetItem.ClientID %> option").remove();
                           if (PatientData.length == 0) {
                               ddlSetItem.append($("<option></option>").val("0").html("Select"));
                           }
                           else {
                               for (i = 0; i < PatientData.length; i++) {
                                   ddlSetItem.append($("<option></option>").val(PatientData[i].SetID).html(PatientData[i].NAME));
                               }
                           }
                       },
                       error: function (xhr, status) {
                           alert("Error ");
                           lstitems.attr("disabled", false);
                           window.status = status + "\r\n" + xhr.responseText;
                       }
                   });
               }

               function SaveDataSet() {
                   $("#<%=lblmsg.ClientID %>,#<%=lblSetError.ClientID %>").text('');
                   $("#btnSaveSet").attr('disabled', true);
                   var Itemdata = "";
                   if ($.trim($("#txtSetName").val()) == "") {
                       $("#<%=lblSetError.ClientID %>").text('Please Enter Set Name');
                       $("#btnSaveSet").attr('disabled', false);
                       $("#txtSetName").focus();
                       $find('mpe').show();
                       return;
                   }
                   Itemdata = $.trim($("#txtSetName").val());
                   $.ajax({
                       url: "Services/SetMaster.asmx/SaveSet",
                       data: '{SetName:"' + Itemdata + '",Description:"' + $.trim($("#<%=txtDescription.ClientID %>").val()) + '"}',
                       type: "POST",
                       contentType: "application/json;charset=utf-8",
                       timeout: 120000,
                       dataType: "json",
                       success: function (result) {
                           Data = (result.d);
                           if (Data == "1") {
                               DisplayMsg('MM01', 'ctl00_ContentPlaceHolder1_lblmsg');

                               $("#txtSetName").val('');
                               $find("mpe").hide();
                               $("#btnSaveSet").attr('disabled', false);
                               loadSets();
                           }
                           else if (Data == "2") {
                               DisplayMsg('MM024', 'ctl00_ContentPlaceHolder1_lblmsg');
                               $find("mpe").hide();
                               $("#btnSaveSet").attr('disabled', false);
                           }
                           else {
                               DisplayMsg('MM07', 'ctl00_ContentPlaceHolder1_lblmsg');
                               $find("mpe").hide();
                               $("#btnSaveSet").attr('disabled', false);
                           }
                       },
                       error: function (xhr, status) {
                           DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
                           $("#btnSaveSet").attr('disabled', false);
                           window.status = status + "\r\n" + xhr.responseText;
                       }
                   });
               }
               function SaveData(event) {

                   if ($.trim($("#<%=ddlSetItem.ClientID %> ").val()) == "0") {
                       DisplayMsg('MM242', 'ctl00_ContentPlaceHolder1_lblmsg');
                       event.preventDefault();
                   }
                   if (event.isDefaultPrevented() == false) {
                       $("#btnSave").attr('disabled', true);
                       var Itemdata = "";
                       $("#tb_grdLabSearch tr").each(function () {
                           var id = $(this).closest("tr").attr("id");
                           var i = 1;
                           if (id != "Header") {
                               $(this).find("td").each(function () {
                                   if (i <= 6) {
                                       Itemdata += $(this).html() + '|';
                                   } i++;
                               });
                               Itemdata = Itemdata + "^"
                           }

                       });
                       Itemdata = Itemdata.replace('"', '');
                       if (Itemdata == "") {
                           DisplayMsg('MM242', 'ctl00_ContentPlaceHolder1_lblmsg');
                           $("#btnSave").attr('disabled', false);
                           return;
                       }
                       $.ajax({
                           url: "Services/SetItems.asmx/SaveSetItem",
                           data: '{ItemData: "' + Itemdata + '"}',
                           type: "POST",
                           contentType: "application/json; charset=utf-8",
                           timeout: 120000,
                           dataType: "json",
                           success: function (result) {
                               Data = result.d;
                               if (Data == "1") {
                                   $("#tb_grdLabSearch tr:not(:first)").remove();
                                   $("#tb_grdLabSearch").hide();
                                   DisplayMsg('MM01', 'ctl00_ContentPlaceHolder1_lblmsg');
                                   $("#btnSave").hide();
                                   bindSet();
                               }
                               else {
                                   $("#<%=lblmsg.ClientID %>").text('Record Not Saved');
                        }
                        $("#btnSave").attr('disabled', false);
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
                        $("#btnSave").attr('disabled', false);
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }
        var RowCount;
        var setId;
        function AddItem() {
            $("#<%=lblmsg.ClientID %>").text('');
            var ItemName = $("#<%=lstitems.ClientID %> option:selected").text();
            var ItemID = $("#<%=lstitems.ClientID %> option:selected").val();
            var Qty = $("#<%=txtQty.ClientID %>").val();
            if (Qty == "" || Qty == "0") {
                alert('Please Enter Quantity');
                $("#<%=txtQty.ClientID %>").focus();
                if ($("#tb_grdLabSearch tr").length == "1") {
                    $("#btnSave").hide();
                }
                else {
                    $("#btnSave").show();
                }
                return;
            }
            if ($("#<%=lstitems.ClientID %> option:selected").length == "0") {
                DisplayMsg('MM018', 'ctl00_ContentPlaceHolder1_lblmsg');
                $("#btnSave").attr('style', 'display:none');
                return;
            }
            RowCount = $("#tb_grdLabSearch tr").length;
            RowCount = RowCount + 1;

            var AlreadySelect = 0;
            if (RowCount > 2) {

                $("#tb_grdLabSearch tr").each(function () {
                    if ($(this).attr("id") == 'tr_' + ItemID) {
                        AlreadySelect = 1;
                        return;
                    }
                });
                if ($("#<%=ddlSetItem.ClientID %>  option:selected").val() != setId) {
                    alert('Set Name Cannot Change');
                    $("#<%=ddlSetItem.ClientID %>").focus();
                    return;
                }
            }
            setId = $("#<%=ddlSetItem.ClientID %>  option:selected").val();
            var setName = $("#<%=ddlSetItem.ClientID %>  option:selected").text();
            if (setName.toUpperCase() == "SELECT") {
                DisplayMsg('MM242', 'ctl00_ContentPlaceHolder1_lblmsg');
                $("#<%=ddlSetItem.ClientID %>").focus();
                $("#btnSave").hide();
                return;
            }
            if (AlreadySelect == "0") {
                var newRow = $('<tr />').attr('id', 'tr_' + ItemID);
                newRow.html('<td class="GridViewLabItemStyle" >' + (RowCount - 1) +
                     '</td><td class="GridViewLabItemStyle" style="display:none;" >' + setId +
                     '</td><td class="GridViewLabItemStyle" style="text-align:left">' + setName +
                     '</td><td  class="GridViewLabItemStyle" style="text-align:left" >' + ItemName +
                     '</td><td  class="GridViewLabItemStyle" style="display:none;" >' + ItemID +
                     '</td><td  class="GridViewLabItemStyle" style="text-align:center" >' + Qty +
                     '</td><td class="GridViewLabItemStyle" style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"  onmouseover="chngcur()" title="Click To Remove" /></td>'
                    );
                $("#tb_grdLabSearch").append(newRow);
                $("#tb_grdLabSearch").show();
                $("#<%=txtQty.ClientID %>").val('');
                $("#btnSave").attr('style', 'display:""');
            }
            else {
                DisplayMsg('MM035', 'ctl00_ContentPlaceHolder1_lblmsg');
                alert('Item Already Selected');
            }
            $('#<% = txtitemsearch.ClientID %>').val('');
            $('#<% = txtitemsearch.ClientID %>').focus();
        }
        function DeleteRow(rowid) {
            var row = rowid;
            $(row).closest('tr').remove();
            RowCount = RowCount - 1;
            if ($("#tb_grdLabSearch tr").length == "1") {
                $("#btnSave").hide();
                $("#tb_grdLabSearch").hide();
            }
            else {
                $("#btnSave").show();
            }
        }
        function CheckQtyRecive(RecievedQty) {
            var TDSAmt = $(RecievedQty).val();
            if (TDSAmt.match(/[^0-9]/g)) {
                TDSAmt = TDSAmt.replace(/[^0-9]/g, '');
                $(RecievedQty).val(TDSAmt)
                return;
            }
        }
        document.onkeyup = Esc;
        function Esc() {
            var KeyID = event.keyCode;
            if (KeyID == 27) {
                if ($find("mpe")) {
                    $find("mpe").hide();
                }
            }
        }
        function clearpopup() {
            $("#<%=lblSetError.ClientID %>").text('');
            $("#txtSetName").val('');
            $("#<%=txtDescription.ClientID %>").val('');
        }
        function pageLoad() {
            var modalPopup = $find("mpe");
            if (modalPopup != null) {
                modalPopup.add_shown(OnPopupShow);
            }
        }
        function OnPopupShow() {
            var tb = $get("txtSetName");
            tb.focus();
        }
        function closeSet() {
            $find("mpe").hide();
            clearpopup();
        }
        function bindSet() {
            $("#<%=ddlSetItem.ClientID %> option").remove();
            $.ajax({
                url: "Services/SetMaster.asmx/BindSet",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    SetData = jQuery.parseJSON(result.d);
                    if (SetData.length == 0) {
                        $("#<%=ddlSetItem.ClientID %>").append($("<option></option>").val("0").html("Select"));
                    }
                    else {
                        for (i = 0; i < SetData.length; i++) {
                            $("#<%=ddlSetItem.ClientID %>").append($("<option></option>").val(SetData[i].SetID).html(SetData[i].NAME));
                        }
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function chngcur() {
            document.body.style.cursor = 'pointer';
        }
        $(function () {
            var MaxLength = 100;
            $("#<% =txtDescription.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $("#<% =txtDescription.ClientID %>").bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
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
        function validatespace() {
            var Name = $("#txtSetName").val();
            if (Name.charAt(0) == ' ' || Name.charAt(0) == '.' || Name.charAt(0) == ',' || Name.charAt(0) == '0' || Name.charAt(0) == "'" || Name.charAt(0) == '-') {
                $("#txtSetName").val('');
                $('#<%=lblSetError.ClientID %>').text('First Character Cannot Be Space/Dot');
                Name.replace(Name.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblSetError.ClientID %>').text('');
                return true;
            }
        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)

            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "43") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "37") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }
            else {
                return true;
            }
        }
        function check1(e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || keychar == "/") {
                return false;
            }
            else {
                return true;
            }
        }
    </script>

    <script type="text/javascript">
        function splcharval(id) {
            id.value = id.value.replace(/[#|\']/g, '');
        }
        //For Search By Word
        function MoveUpAndDownText(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;

                            return;
                        }
                    }
                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }
                }
            }
        }
        function MoveUpAndDownTextCatID(textbox2, listbox2) {
            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            ItemID = listbox.options[m + 1].value.toString().split('#', 2);
                            textbox.value = ItemID[1];
                            return;
                        }
                    }
                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            ItemID = listbox.options[m - 1].value.toString().split('#', 2);
                            textbox.value = ItemID[1];
                            return;
                        }
                    }
                }
            }
        }
        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                var listbox = listbox2;
                var textbox = textbox2;
                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].text.toString().trim();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }
        }

        function suggestNameOnCatalogID(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                var listbox = listbox2;
                var textbox = textbox2;
                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].value.toString().split('#', 2);
                    if (suggestion[1] != '') {
                        if (suggestion[1].length >= level)
                            suggestionID = suggestion[1].substring(0, level).toLowerCase();
                    }
                    else
                        suggestionID = '';
                    if (soFarLeft == suggestionID) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestNameOnCatalogID(textbox, listbox, level) }
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Set-Master Equipment<br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError">
            </asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Set Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:DropDownList ID="ddlSetItem" runat="server" ToolTip="Select Sets">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-1">
                            <asp:Button ID="btnCreateSet" Text="Create Set" CssClass="ItDoseButton" ToolTip="Click To Create New Set"
                                runat="server" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtitemsearch" runat="server" onKeyDown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtitemsearch,ctl00$ContentPlaceHolder1$lstitems);"
                                onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtitemsearch,ctl00$ContentPlaceHolder1$lstitems);">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnRefresh" runat="server" Text="Refresh list" CssClass="ItDoseButton"
                                OnClick="btnRefresh_Click" />
                            <input id="btnAddNewItem" class="ItDoseButton" onclick="wopen('../Store/itemMaster.aspx?Mode=1', 'popup1', 940, 550); return false;"
                                type="button" value="Create Item" style="display: none;" />
                            <asp:TextBox ID="txtitemsearchByCatlogID" runat="server" Style="display: none;" onKeyDown="MoveUpAndDownTextCatID(ctl00$ContentPlaceHolder1$txtitemsearchByCatlogID,ctl00$ContentPlaceHolder1$lstitems);" onkeyup="suggestNameOnCatalogID(ctl00$ContentPlaceHolder1$txtitemsearchByCatlogID,ctl00$ContentPlaceHolder1$lstitems);"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:ListBox ID="lstitems" runat="server" Height="290px" Width="408px" ToolTip="Select Items"></asp:ListBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Qty. In Set
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtQty" ToolTip="Enter Qty." CssClass="ItDoseTextinputNum" runat="server" MaxLength="3" onkeyup="CheckQtyRecive(this);" Width="40px"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbQty" runat="server" FilterType="Numbers" TargetControlID="txtQty">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input id="btnAdd" value="Add" type="button" class="ItDoseButton" title="Click To Add Item" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                    <div class="col-md-1">
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr style="text-align: center">
                    <td colspan="4">
                        <table class="GridViewStyle" rules="all" border="1" id="tb_grdLabSearch"
                            style="width: 100%; border-collapse: collapse; display: none;">
                            <tr id="Header">
                                <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">S.No.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Set Name
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 320px;">Item Name
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Quantity
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Remove
                                </th>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input id="btnSave" value="Save" type="button" class="ItDoseButton" title="Click To Save" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
    </div>
    <asp:Panel ID="pnlSetMaster" runat="server" Style="width: 450px; height:120px; display: none" CssClass="pnlOrderItemsFilter">
        <div runat="server" class="Purchaseheader">
            <b>Create Set </b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
             &nbsp;&nbsp; &nbsp;  <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeSet()" />
                 to close</span></em>
            <asp:Label ID="lblSetError" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="row">
            <div class="col-md-1"></div>
            <div class="col-md-22">
                <div class="row">
                    <div class="col-md-6">
                        <label class="pull-left">
                            Set Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input id="txtSetName" size="34" maxlength="50" value="" title="Enter Set Name" onkeypress="return check(event)"
                            onkeyup="validatespace();" class="requiredField" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <label class="pull-left">
                            Desc.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtDescription" onkeypress="return check(event)" runat="server" Width="272px"
                            TextMode="MultiLine" ToolTip="Enter Set Description"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                    </div>
                    <div class="col-md-8">
                        <input type="button" id="btnSaveSet" value="Save" class="ItDoseButton" />
                        <asp:Button ID="btnCancel" Text="Cancel" CssClass="ItDoseButton" runat="server" />
                    </div>
                    <div class="col-md-8">
                    </div>
                </div>
            </div>
            <div class="col-md-1"></div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpe" runat="server" PopupControlID="pnlSetMaster" DropShadow="true"
        BackgroundCssClass="filterPupupBackground" BehaviorID="mpe" TargetControlID="btnCreateSet"
        CancelControlID="btnCancel" OnCancelScript="clearpopup()">
    </cc1:ModalPopupExtender>
</asp:Content>
