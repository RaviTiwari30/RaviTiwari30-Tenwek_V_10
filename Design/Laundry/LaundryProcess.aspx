<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="LaundryProcess.aspx.cs" Inherits="Design_Laundry_LaundryProcess"
    EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, 
PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
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
            LoadDetail();
        }

        function MoveUpAndDownValue(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
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
            LoadDetail();
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
                    suggestion = listbox.options[m].text.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }

                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }
            LoadDetail();
        }
        function suggestValue(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13) {
                var f = document.theSource;
                var listbox = listbox2;
                var textbox = textbox2;

                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                for (var m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].value.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;

                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(level) }
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            bindItem();
            $('#btnAddItem').click(AddItem);
            $('#btnSave').click(SaveData);
        });
        function laundryData() {
            var dataLaundry = new Array();
            var objLaundry = new Object();
            $("#tbSelected tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "LaundryHeader") {
                    objLaundry.ID = $.trim($rowid.find("#spnID").text());
                    objLaundry.batchType = $.trim($rowid.find("#spnBatchType").text());
                    objLaundry.methodType = $.trim($rowid.find("#spnMethodType").text());
                    objLaundry.type = $("#rblType input[type=radio]:checked").val();
                    objLaundry.StockID = $.trim($rowid.find("#spnStockID").text());
                    objLaundry.DeptLedgerNo = $.trim($rowid.find("#spnDeptLedgerNo").text());
                    objLaundry.ReturnQty = $.trim($rowid.find("#spnProcessQty").text());
                    objLaundry.ItemName = $.trim($rowid.find("#spnItemName").text());
                    objLaundry.ItemID = $.trim($rowid.find("#spnItemID").text());
                    objLaundry.ActualReturnQty = $.trim($rowid.find("#spnActualReturnQty").text());
                    dataLaundry.push(objLaundry);
                    objLaundry = new Object();
                }

            });
            if (objLaundry != "undefined")
                return dataLaundry;
            else
                return ""
        }
        function SaveData() {
            var start_time1 = $('#<%=txtFromTime.ClientID %>').val();
            var end_time1 = $('#<%=txtToTime.ClientID %>').val();
            var stt1 = new Date("November 13, 2013 " + start_time1);
            stt1 = stt1.getTime();
            var endt1 = new Date("November 13, 2013 " + end_time1);
            endt1 = endt1.getTime();
            var start11 = $("#<%=FrmDate.ClientID %>").val();
            var end11 = $("#<%=ToDate.ClientID %>").val();

            var splitdate11 = start11.split("-");
            var dt111 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];
            var splitdate111 = end11.split("-");
            var dt211 = splitdate111[1] + " " + splitdate111[0] + ", " + splitdate111[2];

            var newStartDate11 = Date.parse(dt111);
            var newEndDate112 = Date.parse(dt211);

            var start_time1 = $('#<%=txtFromTime.ClientID %>').val();
            var end_time1 = $('#<%=txtToTime.ClientID %>').val();
            var stt1 = new Date("November 13, 2013 " + start_time1);
            stt1 = stt1.getTime();
            var endt1 = new Date("November 13, 2013 " + end_time1);
            endt1 = endt1.getTime();
            if ((newStartDate11 + stt1) > (newEndDate112 + endt1)) {
                alert('Approx End Date Time always greater then Start Date Time');
                return;
            }
            $('#btnSave').attr('disabled', true);

            if ($("#ddlMachineName").val() == "0") {
                $("#<%=lblmsg.ClientID %>").text('Please Select Machine Name');
                $("#ddlMachineName").focus();
                $("#btnSave").attr('disabled', false);
                return;
            }

            var resultLaundryData = laundryData();

            if (resultLaundryData == "") {
                DisplayMsg('MM018', 'ctl00_ContentPlaceHolder1_lblmsg');
                $("#btnSave").attr('disabled', false);
                return;
            }
            var startDate = $('#<%= FrmDate.ClientID %>').val() + ' ' + $("#<%=txtFromTime.ClientID %>").val();
            var endDate = $('#<%= ToDate.ClientID %>').val() + ' ' + $("#<%=txtToTime.ClientID %>").val();
            $.ajax({
                url: "Services/LaundryProcess.asmx/UpdateProcessing",
                data: JSON.stringify({ laundry: resultLaundryData, startDate: startDate, endDate: endDate, machineID: $("#ddlMachineName").val(), machineName: $("#ddlMachineName option:selected").text(), Remark: $("#txtRemark").val(), post: $("#chkPost").is(':checked') }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        $("#tbSelected tr:not(:first)").remove();
                        $("#tbSelected").hide();
                        $("#divreturn").hide();
                       // DisplayMsg('MM01', 'ctl00_ContentPlaceHolder1_lblmsg');
                        alert('Record Saved Successfully');
                        $('#rblType [type=radio][value=1]').prop('checked', true);
                        $('#rblType [type=radio]').removeAttr('disabled');
                        bindItem();
                        $("#<%=txtRemark.ClientID %>").val('');
                        $('#BoilerDetail').attr('style', 'display:none');
                        getDateTime();
                    }
                    else {
                        //DisplayMsg('MM07', 'ctl00_ContentPlaceHolder1_lblmsg');
                        alert('Error');
                    }
                    $("#btnSave").attr('disabled', false);
                },
                error: function (xhr, status) {
                    $("#btnSave").attr('disabled', false);
                }
            });
        }
        function checkAll(checked) {
            $("#tb_grdLabSearch tr").each(function () {
                $(this).find("#chk").attr("checked", checked.checked);
            });
        }
        function TimeCompare() {
            var a = 0;
            var start_time = $('#<%=txtFromTime.ClientID %>').val();
            var end_time = $('#<%=txtToTime.ClientID %>').val();
            var stt = new Date("November 13, 2013 " + start_time);
            stt = stt.getTime();
            var endt = new Date("November 13, 2013 " + end_time);
            endt = endt.getTime();
            if (stt > endt) {
                alert('Approx End-time always greater then Start-time');
                return;
            }
        }
        function ValidateDate() {
            var start1 = $("#<%=FrmDate.ClientID %>").val();
            var end1 = $("#<%=ToDate.ClientID %>").val();

            var splitdate1 = start1.split("-");
            var dt11 = splitdate1[1] + " " + splitdate1[0] + ", " + splitdate1[2];
            var splitdate11 = end1.split("-");
            var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];

            var newStartDate1 = Date.parse(dt11);
            var newEndDate1 = Date.parse(dt21);

            if (newStartDate1 > newEndDate1) {
                alert("Approx Of End Date should be greater than Start Date");
                $("#<%=ToDate.ClientID %>").focus();
                return;
            }
        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer  
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera  
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
        function checkDate(sender, args) {
            alert(sender._selectedDate); alert($("#<%=FrDate.ClientID %>").val());
            if (sender._selectedDate < $("#<%=FrDate.ClientID %>").val()) {
                alert(sender._selectedDate);
                alert("You cannot select a day earlier than today!");
                sender._selectedDate = new Date();
                // set the date back to the current date
                sender._textbox.set_Value(sender._selectedDate.format(sender._format))
            }
        }
        function ValidateDate1() {
            var start1 = $("#<%=FrDate.ClientID %>").val();
            var end1 = $("#<%=FrmDate.ClientID %>").val();

            var splitdate1 = start1.split("-");
            var dt11 = splitdate1[1] + " " + splitdate1[0] + ", " + splitdate1[2];
            var splitdate11 = end1.split("-");
            var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];

            var newStartDate1 = Date.parse(dt11);
            var newEndDate1 = Date.parse(dt21);

            if (newStartDate1 > newEndDate1) {
                alert("Approx Of Start Date should be greater than Process Date " + start1);
                $("#<%=FrmDate.ClientID %>").focus();
                $("#<%=FrmDate.ClientID %>").val(start1);
                return;
            }
        }
    </script>
    <script type="text/javascript">
        function GenerateCloseButton(sender, e) {
            if ($('#ajax__calendar_close_button').length == 0) {
                $(sender._header).before("<div id='ajax__calendar_close_button'>x</div>");
                $('#ajax__calendar_close_button').bind("click", sender, function (e) {
                    $find("calFromDate").hide();
                    $("#<%=calFrmDate.ClientID%>").hide();
                });
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager2" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true" />

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Laundry Process</b><br />
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
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:RadioButtonList ID="rblType" ClientIDMode="Static" onclick="bindItem()" runat="server" RepeatDirection="Horizontal" RepeatColumns="4">
                            <asp:ListItem Text="Washing" Selected="True" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Dryer" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Ironing" Value="3"></asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" ToolTip="Select Department" TabIndex="1" runat="server" ClientIDMode="Static" onchange="bindItem()">
                        </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search by Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                            <asp:TextBox ID="txtSearch" runat="server" onKeyDown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00$ContentPlaceHolder1$lsbItem);"
                                onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00$ContentPlaceHolder1$lsbItem);" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Items
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:ListBox ID="lsbItem" TabIndex="4" runat="server"
                            Width="420px" Height="100px" onchange="LoadDetail();"></asp:ListBox>
                        </div>
                        <div id="divreturn" style="display:none;">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Returned Qty.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <span id="spnRequestedQty"  class="ItDoseLabelSp"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Return Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <span id="spnReturnDate"  class="ItDoseLabelSp"></span>
                        </div><br />
                            
                        <div id="divComment" style="display:none;">
                            <div class="col-md-3">
                            <label class="pull-left">
                                Comment 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <span id="spnComment"  class="ItDoseLabelSp"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                              Dept. From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <span id="spnfromDept"  class="ItDoseLabelSp"></span>
                        </div>
                        </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Qty.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtQty" runat="server" ClientIDMode="Static" MaxLength="4" Width="60px" CssClass="requiredField"></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="ftbQty" runat="server" TargetControlID="txtQty"  FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </div>
                        </div>
                        <div class="row" id="trBatchType">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Batch Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBatchType" runat="server" ClientIDMode="Static" onchange="showMethodType()">
                            <asp:ListItem Text="Normal" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Infected" Value="2"></asp:ListItem>
                        </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row" id="MethodType">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Method Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMethodType" runat="server" ClientIDMode="Static" CssClass="requiredField">
                            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Parazole" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Softner" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Clax" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Destolight" Value="4"></asp:ListItem>
                        </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input type="button" value="Add Item" id="btnAddItem" class="ItDoseButton" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
		<div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; border-collapse: collapse">
            <div id="LaundryOutput" style="max-height: 200px; overflow-y: auto; text-align: center">
                <table id="tbSelected" rules="all" style="width: 100%; display: none" class="GridViewStyle">
                    <tr id="LaundryHeader">
                        <th class="GridViewHeaderStyle" scope="col" style="width: 25%; text-align: center">Item Name</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 10%; text-align: left; display: none">Item ID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 10%; text-align: left; display: none">StockID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 15%; text-align: center;">Return Date</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 15%; text-align: center">Return Qty.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 10%; text-align: left; display: none">ID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 25%; text-align: center;">From Dept.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 25%; text-align: center;">Comment</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 10%; text-align: left; display: none">BatchType</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 10%; text-align: left; display: none">MethodType</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 20%; text-align: center;">Process Qty.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 10%; text-align: center;display: none">DeptLedgerNo</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 20%; text-align: center">Remove</th>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="display: none;" id="BoilerDetail">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Machine Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMachineName" ClientIDMode="Static" runat="server" CssClass="requiredField"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Actual Start Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="FrmDate" runat="server" onchange="ValidateDate1();"></asp:TextBox>
                        <asp:TextBox ID="FrDate" Style="display: none" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="calFrmDate" runat="server" BehaviorID="calFromDate" Animated="true" TargetControlID="FrmDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtFromTime" runat="server"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="mee_txtFromTime" runat="server" MaskType="Time" AcceptNegative="None"
                                AcceptAMPM="true" TargetControlID="txtFromTime" Mask="99:99">
                            </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                            ControlExtender="mee_txtFromTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                            </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Actual End Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="ToDate" runat="server" onchange="javascript:ValidateDate();"></asp:TextBox>
                        <cc1:CalendarExtender ID="calToDate" runat="server" BehaviorID="calEndDate" TargetControlID="ToDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtToTime" runat="server" ></asp:TextBox>
                        <cc1:MaskedEditExtender ID="mee_txtToTime" runat="server" MaskType="Time" AcceptNegative="None"
                            AcceptAMPM="true" TargetControlID="txtToTime" Mask="99:99">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtToTime"
                            ControlExtender="mee_txtToTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                            </div>
                    </div>
                    <div class="row" id="tdPost">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Post
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkPost" runat="server" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Remark
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRemark" runat="server" ClientIDMode="Static" MaxLength="50" ToolTip="Enter Remark" onkeypress="return check(event)"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="cfdremark" runat="server" TargetControlID="txtRemark" FilterType="LowercaseLetters,UppercaseLetters,Numbers,Custom"
                            ValidChars="?,. ">
                        </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input type="button" value="Save" class="ItDoseButton" id="btnSave" />
                        </div>
                        <div class="col-md-11">
                            </div>
                    </div>
                </div>
		<div class="col-md-1"></div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function showMethodType() {
            if ($("#ddlBatchType").val() == "2") {
                $("#MethodType").show();
            }
            else {
                $("#MethodType").hide();
            }
            $("#ddlMethodType").get(0).selectedIndex = 0;
        }
    </script>
    <script type="text/javascript">
        function AddItem() {
            
            $("#<%=lblmsg.ClientID %>").text('');
            if (($("#<%=lsbItem.ClientID %> option:selected").text().toUpperCase() == "") || ($("#<%=lsbItem.ClientID %>").val()=="0")) {
                $("#<%=lblmsg.ClientID %>").text('Please Select Items');
                return;
            }
            if ($.trim($("#txtQty").val()) == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Process Quantity');
                $("#txtQty").focus();
                return;
            }
            if (parseFloat($("#<%=lsbItem.ClientID %>").val().split('#')[2]) < parseFloat($("#txtQty").val()) ) {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Valid Process Quantity');
                $("#txtQty").focus();
                return;
            }
            if (($("#ddlBatchType").val() == "2") && ($("#ddlMethodType").val() == "0")) {
                $("#<%=lblmsg.ClientID %>").text('Please Select Method Type');
                $("#ddlMethodType").focus();
                return;
            }
            var processID = $("#<%=lsbItem.ClientID %>").val().split('#')[0];
            var AlreadySelect = 0;
            $('#tbSelected tr:not(#LaundryHeader)').each(function () {
                if ($(this).find('#spnID').text().trim() == processID) {
                    AlreadySelect = AlreadySelect + 1;
                    return;
                }
            });
            if (AlreadySelect == "0") {
                if (($("#rblType input[type=radio]:checked").val() == "2") || ($("#rblType input[type=radio]:checked").val() == "3")) {
                    $("#tdPost").show();
                    if ($("#rblType input[type=radio]:checked").val() == "3") {
                        $("#chkPost").prop('checked', true).attr('disabled', 'disabled');
                    }
                }
                else {
                    $("#tdPost").hide();
                    $("#chkPost").prop('checked', false).removeAttr('disabled');
                }
                $("#<%=lblmsg.ClientID %>").text('');
                $.ajax({
                    url: "Services/LaundryProcess.asmx/addDirtyItem",
                    data: '{ID:"' + processID + '",type:"' + $("#rblType input[type=radio]:checked").val() + '"}',
                    type: "POST",
                    contentType: "application/json;charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d != null) {
                            dirtyItem = jQuery.parseJSON(result.d);
                            $('#tbSelected').css('display', 'block');
                            $('#tbSelected').append('<tr><td class="GridViewLabItemStyle"><span id="spnItemName">' + $("#<%=lsbItem.ClientID %> option:selected").text() + '</span></td><td class="GridViewLabItemStyle" style="display:none"><span id="spnItemID">' + dirtyItem[0].itemID + '</span></td><td class="GridViewLabItemStyle" style="display:none"><span id="spnStockID" >' + dirtyItem[0].StockID + '</span></td><td class="GridViewLabItemStyle" ><span id="spnReturnDate" >' + $("#<%=lsbItem.ClientID %>").val().split('#')[1] + '</span> </td><td class="GridViewLabItemStyle" ><span id="spnReturnQty" >' + $("#<%=lsbItem.ClientID %>").val().split('#')[2] + '</span> </td><td class="GridViewLabItemStyle" style="display:none"><span id="spnID" >' + dirtyItem[0].ID + '</span><span id="spnActualReturnQty" >' + dirtyItem[0].actualReturnQty + '</span> </td><td class="GridViewLabItemStyle"><span id="spnFromDept" >' + dirtyItem[0].LedgerName + '</span> </td><td class="GridViewLabItemStyle"><span id="spnFromDept" >' + dirtyItem[0].Remark + '</span> </td><td class="GridViewLabItemStyle" style="display:none"><span id="spnBatchType" >' + $("#ddlBatchType option:selected").text() + '</span> </td><td class="GridViewLabItemStyle" style="display:none"><span id="spnMethodType" >' + $("#ddlMethodType option:selected").text() + '</span> </td><td class="GridViewLabItemStyle"><span id="spnProcessQty" >' + $("#txtQty").val() + '</span> </td><td class="GridViewLabItemStyle" style="display:none"><span id="spnDeptLedgerNo" >' + dirtyItem[0].FromDept + '</span> </td>   <td class="GridViewLabItemStyle"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer" /></td></tr>');
                            $('#BoilerDetail').attr('style', 'display:""');
                            $("#txtQty").val('');
                            if ($('#tbSelected tr:not(#LaundryHeader)').length == "1")
                                bindMachine();
                        }
                    },
                    error: function (xhr, status) {
                        $("#<%=lblmsg.ClientID %>").text('Error occurred, Please contact administrator');
                    }
                });
            }
            else {
                $("#<%=lblmsg.ClientID %>").text('Selected Item Already Added');
                return;
            }

            if ($('#tbSelected tr:not(#LaundryHeader)').length >= 0) {
                $("#rblType input[type=radio]").attr('disabled', 'disabled');
            }
            else {
                $("#rblType input[type=radio]").removeAttr('disabled');
            }
        }
    </script>
    <script type="text/javascript">
        function bindItem() {
            if ($("#rblType input[type=radio]:checked").val() != "1") {
                $("#trBatchType,#MethodType").hide();
                $("#ddlMethodType,#ddlBatchType").get(0).selectedIndex = 0;
            }
            else if ($("#rblType input[type=radio]:checked").val() == "1") {
                $("#trBatchType").show();
                $("#MethodType").hide();
                $("#ddlMethodType,#ddlBatchType").get(0).selectedIndex = 0;
            }
            var lsbItem = $("#<%=lsbItem.ClientID %>");
            $("#<%=lsbItem.ClientID %> option").remove();
            $.ajax({
                url: "Services/LaundryProcess.asmx/LoadDirtyItem",
                data: '{fromDept:"' + $("#ddlDept").val() + '",type:"' + $("#rblType input[type=radio]:checked").val() + '"}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    itemData = jQuery.parseJSON(result.d);
                    if (itemData.length == 0) {
                        lsbItem.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < itemData.length; i++) {
                            lsbItem.append($("<option></option>").val(itemData[i].ID).html(itemData[i].ItemName));
                        }
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function RemoveRows(rowid) {
            $(rowid).closest('tr').remove();
            if ($('#tbSelected tr:not(#LaundryHeader)').length == 0) {
                $('#tbSelected,#BoilerDetail').hide();
                $("#rblType input[type=radio]").removeAttr('disabled');
            }
            else {
                $("#rblType input[type=radio]").attr('disabled', 'disabled');
            }
        }
        function bindMachine() {
            $("#ddlMachineName option").remove();
            $.ajax({
                url: "Services/LaundryProcess.asmx/loadMachine",
                data: '{type:"' + $("#rblType input[type=radio]:checked").val() + '"}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != null) {
                        MachineData = jQuery.parseJSON(result.d);
                        $("#ddlMachineName").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < MachineData.length; i++) {
                            $("#ddlMachineName").append($("<option></option>").val(MachineData[i].ID).html(MachineData[i].MachineName));
                        }
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
    </script>
    <script type="text/javascript">
        function getDateTime() {
            $.ajax({
                url: "Services/LaundryProcess.asmx/getDateTime",
                data: '{}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $("#<%=FrmDate.ClientID %>,#<%=ToDate.ClientID %>").val(result.d.split('#')[0]);
                    $('#<%=txtFromTime.ClientID %>,#<%=txtToTime.ClientID %>').val(result.d.split('#')[1]);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function LoadDetail() {
            var strItem = $('#<%=lsbItem.ClientID %>').val();
            if (strItem != null) {
                $("#spnfromDept").text(strItem.split('#')[4]);
                $("#spnComment").text(strItem.split('#')[3]);
                $("#spnRequestedQty").text(strItem.split('#')[2]);
                $("#spnReturnDate").text(strItem.split('#')[1]);
                $("#divreturn").show();
                if (strItem.split('#')[3] != "" || strItem.split('#')[4] != "")
                {
                    $("#divComment").show();
                }
            }
            else {
                $("#spnRequestedQty,#spnReturnDate,#spnComment,#spnfromDept").text('');
                $("#divreturn").hide();

                $("#divComment").hide();
            }
          }
    </script>
</asp:Content>
