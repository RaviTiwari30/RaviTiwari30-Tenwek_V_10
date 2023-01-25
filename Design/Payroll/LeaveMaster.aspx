<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="LeaveMaster.aspx.cs" Inherits="Design_Payroll_LeaveMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function displayValidationResult() {

            if (typeof (Page_Validators) == "undefined") return;

            var LeaveName = document.getElementById("<%=reqLeaveName.ClientID%>");
            var NoOfLeave = document.getElementById("<%=reqNoofLeave.ClientID%>");
            var MinLimit = document.getElementById("<%=reqMinLimit.ClientID%>");
            var Max = document.getElementById("<%=reqMax.ClientID%>");
            var MaxCon = document.getElementById("<%=reqMaxCon.ClientID%>");
            var LeaveApp = document.getElementById("<%=reqLeaveApp.ClientID%>");
            var Gape = document.getElementById("<%=reqGape.ClientID%>");
            var SNo = document.getElementById("<%=reqSNo.ClientID%>");
            var LblName = document.getElementById("<%=lblMsg.ClientID%>");
            var FromExp = document.getElementById("<%=reqFromExp.ClientID%>");
            var ToExp = document.getElementById("<%=reqToExp.ClientID%>");

            ValidatorValidate(LeaveName);
            if (!LeaveName.isvalid) {
                LblName.innerText = LeaveName.errormessage;
                return false;
            }
            ValidatorValidate(Grade);
            if (!Grade.isvalid) {
                LblName.innerText = Grade.errormessage;
                return false;
            }
            ValidatorValidate(FromExp);
            if (!FromExp.isvalid) {
                LblName.innerText = FromExp.errormessage;
                return false;
            }
            ValidatorValidate(ToExp);
            if (!ToExp.isvalid) {
                LblName.innerText = ToExp.errormessage;
                return false;
            }
            if (eval($("#<%=txtFromExperience.ClientID %>").val()) >= eval($("#<%=txtToExperience.ClientID %>").val())) {
                alert('Experience From Always Greater Then  Experience To');
                $("#<%=txtToExperience.ClientID %>").focus();
                return false;
            }
            ValidatorValidate(NoOfLeave);
            if (!NoOfLeave.isvalid) {
                LblName.innerText = NoOfLeave.errormessage;
                return false;
            }
            ValidatorValidate(MinLimit);
            if (!MinLimit.isvalid) {
                LblName.innerText = MinLimit.errormessage;
                return false;
            }
            ValidatorValidate(Max);
            if (!Max.isvalid) {
                LblName.innerText = Max.errormessage;
                return false;
            }
            ValidatorValidate(MaxCon);
            if (!MaxCon.isvalid) {
                LblName.innerText = MaxCon.errormessage;
                return false;
            }
            ValidatorValidate(LeaveApp);
            if (!LeaveApp.isvalid) {
                LblName.innerText = LeaveApp.errormessage;
                return false;
            }
            ValidatorValidate(Gape);
            if (!Gape.isvalid) {
                LblName.innerText = Gape.errormessage;
                return false;
            }
            ValidatorValidate(SNo);
            if (!SNo.isvalid) {
                LblName.innerText = SNo.errormessage;
                return false;
            }
            var start = $("#<%=txtDateMonthFrom.ClientID %>").val();
            var end = $("#<%=txtDateMonthTo.ClientID %>").val();
            var splitdate = start.split("-");
            var dt11 = splitdate[1] + " " + splitdate[0] + ", " + "2014";

            var splitdate11 = end.split("-");
            var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + "2014";
            var newStartDate1 = Date.parse(dt11);
            var newEndDate1 = Date.parse(dt21);
            if (newStartDate1 > newEndDate1) {
                $("#<%=lblMsg.ClientID%>").text('Leave To should be greater than Leave From');
                return false;
            }
            document.getElementById('<%=btnLeaveSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnLeaveSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnLeaveSave', '');

        }
    </script>
    <script type="text/javascript">
        
        function validateExpTo() {

            if (eval($("#<%=txtFromExperience.ClientID %>").val()) >= eval($("#<%=txtToExperience.ClientID %>").val())) {
                alert('Experience From Always Greater Then  Experience To');
                $("#<%=txtToExperience.ClientID %>").focus();
                return false;
            }
        }
        function validateExpFrom() {

        }
        function validateLeave() {
            if ($.trim($("#<%=txtLeaveName.ClientID %>").val()) == "") {
                $("#<%=lblLeaveError.ClientID %>").text('Please Enter Leave Name');
                $("#<%=txtLeaveName.ClientID %>").focus();
                return false;
            }
            if ($.trim($("#<%=txtLeaveDescription.ClientID %>").val()) == "") {
                $("#<%=lblLeaveError.ClientID %>").text('Please Enter Leave Description');
                $("#<%=txtLeaveDescription.ClientID %>").focus();
                return false;
            }
            $("#<%=btnLeaveSave.ClientID%>").attr("disabled", "disabled");
            $("#<%=btnLeaveSave.ClientID%>").val('Submitting...');
            __doPostBack('ctl00$ContentPlaceHolder1$btnLeaveSave', '');
        }
        function clear() {
            $("#<%=txtLeaveName.ClientID %>").val('');
            $("#<%=txtLeaveDescription.ClientID %>").val('');
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpLeave")) {
                    $find("mpLeave").hide();
                    $("#<%=txtLeaveName.ClientID %>").val('');
                    $("#<%=txtLeaveDescription.ClientID %>").val('');
                }
            }
        }
        $(document).ready(function () {
            var MaxLength = 200;
            $("#<% =txtLeaveDescription.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtLeaveDescription.ClientID%>').bind("keypress", function (e) {
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
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=ddlUserGroup.ClientID %>").attr("disabled", "disabled");
            $("#<%=txtFromExperience.ClientID %>").attr("disabled", "disabled");
            $("#<%=txtToExperience.ClientID %>").attr("disabled", "disabled");
        });

        function EnableGrade() {
            $("#<%=ddlUserGroup.ClientID %>").get(0).selectedIndex = 0;
            $("#<%=txtFromExperience.ClientID %>").attr("disabled", "disabled").val('');
            $("#<%=txtToExperience.ClientID %>").attr("disabled", "disabled").val('');
            if ($("#<%=ddlLeaveName.ClientID %>").val() != "Select") {
                $("#<%=ddlUserGroup.ClientID %>").removeAttr("disabled", "disabled");
                $("#<%=txtFromExperience.ClientID %>").removeAttr("disabled", "disabled");
                $("#<%=txtToExperience.ClientID %>").removeAttr("disabled", "disabled");
            }
            else {
                $("#<%=ddlUserGroup.ClientID %>").get(0).selectedIndex = 0;
                $("#<%=ddlUserGroup.ClientID %>").attr("disabled", "disabled").val('');
                $("#<%=txtFromExperience.ClientID %>").attr("disabled", "disabled").val('');
                $("#<%=txtToExperience.ClientID %>").attr("disabled", "disabled").val('');
            }
        }
    </script>
    <script type="text/javascript">
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function CheckExp(Exp) {
            var TExp = $(Exp).val();
            if (TExp.indexOf('.') != -1) {
                var DigitsAfterDecimal = 1;
                var valIndex = TExp.indexOf(".");
                if (valIndex > "0") {
                    if (TExp.length - (TExp.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        $(Exp).val($(Exp).val().substring(0, ($(Exp).val().length - 1)));
                        return false;
                    }
                }
            }
        }
        function onCalendarShown(sender, args) {
            sender._switchMode("days", true);
            changeCellHandlers(cal1);

        }
        function changeCellHandlers(cal) {
            if (cal._monthsBody) {
                //remove the old handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $common.removeHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
                //add the new handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $addHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
            }
        }
        var cal1;
        function pageLoad() {
            cal1 = $find("calendar1");
            modifyCalDelegates(cal1);
        }
        function modifyCalDelegates(cal) {
            //we need to modify the original delegate of the month cell.
            cal._cell$delegates =
            {
                mouseover: Function.createDelegate(cal, cal._cell_onmouseover),
                mouseout: Function.createDelegate(cal, cal._cell_onmouseout),

                click: Function.createDelegate(cal, function (e) {

                    e.stopPropagation();
                    e.preventDefault();

                    if (!cal._enabled) return;

                    var target = e.target;
                    var visibleDate = cal._getEffectiveVisibleDate();
                    Sys.UI.DomElement.removeCssClass(target.parentNode, "ajax__calendar_hover");
                    switch (target.mode) {
                        case "prev":
                        case "next":
                            cal._switchMonth(target.date);
                            break;
                        case "title":
                            switch (cal._mode) {
                                case "days": cal._switchMode("months"); break;
                                    // case "months": cal._switchMode("years"); break;
                            }
                            break;
                        case "month":
                            //if the mode is month, then stop switching to day mode.
                            if (target.month == visibleDate.getMonth()) {
                                this._switchMode("days");
                            }
                            else {
                                cal._visibleDate = target.date;
                                this._switchMode("days");
                            }
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;

                            //  case "year":
                            //    if (target.date.getFullYear() == visibleDate.getFullYear()) {
                            //         cal._switchMode("months");
                            //    }
                            //    else {
                            //        cal._visibleDate = target.date;
                            //        cal._switchMode("months");
                            //    }
                            //   break;

                        case "day":
                            this.set_selectedDate(target.date);
                            this._switchMonth(target.date);
                            this._blur.post(true);
                            this.raiseDateSelectionChanged();
                            break;
                        case "today":
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;
                    }

                }

                )
            }

        }
        function onCalendarShownTo(sender, args) {
            //set the default mode to month
            sender._switchMode("days", true);
            changeCellHandlersTo(cal1);

        }
        function changeCellHandlersTo(cal) {
            if (cal._monthsBody) {
                //remove the old handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $common.removeHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
                //add the new handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $addHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
            }
        }
        var cal1;
        function pageLoad() {
            cal1 = $find("calendar2");
            modifyCalDelegatesTo(cal1);
        }
        function modifyCalDelegatesTo(cal) {
            //we need to modify the original delegate of the month cell.
            cal._cell$delegates =
            {
                mouseover: Function.createDelegate(cal, cal._cell_onmouseover),
                mouseout: Function.createDelegate(cal, cal._cell_onmouseout),

                click: Function.createDelegate(cal, function (e) {

                    e.stopPropagation();
                    e.preventDefault();

                    if (!cal._enabled) return;

                    var target = e.target;
                    var visibleDate = cal._getEffectiveVisibleDate();
                    Sys.UI.DomElement.removeCssClass(target.parentNode, "ajax__calendar_hover");
                    switch (target.mode) {
                        case "prev":
                        case "next":
                            cal._switchMonth(target.date);
                            break;
                        case "title":
                            switch (cal._mode) {
                                case "days": cal._switchMode("months"); break;
                                    // case "months": cal._switchMode("years"); break;
                            }
                            break;
                        case "month":
                            //if the mode is month, then stop switching to day mode.
                            if (target.month == visibleDate.getMonth()) {
                                this._switchMode("days");
                            }
                            else {
                                cal._visibleDate = target.date;
                                this._switchMode("days");
                            }
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;

                            //  case "year":
                            //    if (target.date.getFullYear() == visibleDate.getFullYear()) {
                            //         cal._switchMode("months");
                            //    }
                            //    else {
                            //        cal._visibleDate = target.date;
                            //        cal._switchMode("months");
                            //    }
                            //   break;

                        case "day":
                            this.set_selectedDate(target.date);
                            this._switchMonth(target.date);
                            this._blur.post(true);
                            this.raiseDateSelectionChanged();
                            break;
                        case "today":
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;
                    }

                }

                )
            }

        }

        function ValidateDate() {
            var start = $("#<%=txtDateMonthFrom.ClientID %>").val();
            var end = $("#<%=txtDateMonthTo.ClientID %>").val();
            var splitdate = start.split("-");
            var dt11 = splitdate[1] + " " + splitdate[0] + ", " + "2014";

            var splitdate11 = end.split("-");
            var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + "2014";
            var newStartDate1 = Date.parse(dt11);
            var newEndDate1 = Date.parse(dt21);
            if (newStartDate1 > newEndDate1) {
                alert("Leave To should be greater than Leave From");
                return false;
            }

        }

        function closeLeave() {
            if ($find("mpLeave")) {
                $find("mpLeave").hide();
                $("#<%=txtLeaveName.ClientID %>").val('');
                $("#<%=txtLeaveDescription.ClientID %>").val('');
            }
        }
    </script>
    <Ajax:ScriptManager ID="sm" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Leave Master </b>
            <br />
            <asp:Label ID="lblMsg" CssClass="ItDoseLblError" runat="server"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Leave Details
            </div>
            <div class="row">
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Leave Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlLeaveName" onchange="EnableGrade()" ToolTip="Select Leave Name"
                                runat="server" CssClass="requiredField" TabIndex="1">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="reqLeaveName" runat="server" ControlToValidate="ddlLeaveName"
                                Display="None" InitialValue="Select" ValidationGroup="a" ErrorMessage="Please Select Leave Name"
                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-1">
                            <input type="button" id="btnLeave" value="New" class="ItDoseButton" TabIndex="2" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                           <%-- <asp:DropDownList ID="ddlGrade" onchange="BindExperience()" TabIndex="3" ToolTip="Select Grade"
                                runat="server" CssClass="requiredField">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="reqGrade" runat="server" ControlToValidate="ddlGrade"
                                Display="None" InitialValue="0" ValidationGroup="a" ErrorMessage="Please Select Grade"
                                SetFocusOnError="True"></asp:RequiredFieldValidator>--%>
                            <asp:DropDownList ID="ddlUserGroup" runat="server" TabIndex="3" CssClass="requiredField"></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Experience (Years) From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <asp:TextBox ID="txtFromExperience" MaxLength="5" onkeyup="return validateExpFrom()"
                                onkeypress="return checkForSecondDecimal(this,event)" AutoCompleteType="Disabled"
                                CssClass="requiredField" runat="server" TabIndex="4"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqFromExp" runat="server" ControlToValidate="txtFromExperience"
                                Display="None" ValidationGroup="a" ErrorMessage="Please Enter From Experience"
                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">To</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <asp:TextBox ID="txtToExperience" MaxLength="5" CssClass="requiredField" onblur="return validateExpTo()"
                                runat="server" onkeyup="CheckExp(this);" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="5"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqToExp" runat="server" ControlToValidate="txtToExperience"
                                Display="None" ValidationGroup="a" ErrorMessage="Please Enter To Experience"
                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                            <cc1:FilteredTextBoxExtender ID="ftbFromExp" runat="server" ValidChars=".0123456789"
                                TargetControlID="txtFromExperience">
                            </cc1:FilteredTextBoxExtender>
                            <cc1:FilteredTextBoxExtender ID="ftbToExp" runat="server" ValidChars=".0123456789"
                                TargetControlID="txtToExperience">
                            </cc1:FilteredTextBoxExtender>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                No. Of Leave
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtNoOfLeave" TabIndex="6" MaxLength="3" ToolTip="Enter No. of Leave"
                                runat="server" CssClass="requiredField"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="txtMaxLimit0_FilteredTextBoxExtender" runat="Server"
                                TargetControlID="txtNoOfLeave" FilterMode="ValidChars" FilterType="Custom,Numbers"
                                ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RequiredFieldValidator ID="reqNoofLeave" runat="server" ControlToValidate="txtNoOfLeave"
                                Display="None" ValidationGroup="a" ErrorMessage="Please Enter No. Of Leave" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Leave From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtDateMonthFrom" runat="server" ClientIDMode="Static"
                                ToolTip="Click to Select" onchange="javascript:ValidateDate();" TabIndex="7"></asp:TextBox>
                            <cc1:CalendarExtender ID="calDate" OnClientShown="onCalendarShown" BehaviorID="calendar1"
                                runat="server" Format="dd-MMM" TargetControlID="txtDateMonthFrom">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Leave To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtDateMonthTo" runat="server" ClientIDMode="Static"
                                ToolTip="Click to Select" onchange="javascript:ValidateDate();" TabIndex="8"></asp:TextBox>
                            <cc1:CalendarExtender ID="calDateMonthTo" OnClientShown="onCalendarShownTo" BehaviorID="calendar2"
                                runat="server" Format="dd-MMM" TargetControlID="txtDateMonthTo">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Min. Limit
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtMinLimit" Text="1" runat="server" CssClass="requiredField" TabIndex="9" ToolTip="Enter Min. Limit"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="Server" TargetControlID="txtMinLimit"
                                FilterType="Custom,Numbers" FilterMode="ValidChars" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="Server" TargetControlID="txtMinLimit"
                                FilterType="Custom,Numbers" FilterMode="ValidChars" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RequiredFieldValidator ID="reqMinLimit" runat="server" ControlToValidate="txtMinLimit"
                                Display="None" ValidationGroup="a" ErrorMessage="Please Enter Min. Limit" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Max. Continuosly Limit(In Probation)
                            </label>
                        </div>
                        <div class="col-md-1">
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtMaxContinuoslyLimit" runat="server" CssClass="requiredField" TabIndex="10"
                                ToolTip="Enter Max. Continuosly Limit(Probation Period)"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="txtMinLimit0_FilteredTextBoxExtender" runat="Server"
                                TargetControlID="txtMaxContinuoslyLimit" FilterType="Custom,Numbers" FilterMode="ValidChars"
                                ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RequiredFieldValidator ID="reqMax" runat="server" ControlToValidate="txtMaxContinuoslyLimit"
                                Display="None" ValidationGroup="a" ErrorMessage="Please Enter Max. Continuosly Limit"
                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Max. Continuosly Limit
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtMaxContinuoslyLimit2" runat="server" CssClass="requiredField" TabIndex="11"
                                ToolTip="Please Enter Max. Continuosly Limit"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtMaxContinuoslyLimit2"
                                FilterType="Custom,Numbers" FilterMode="ValidChars" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RequiredFieldValidator ID="reqMaxCon" runat="server" ControlToValidate="txtMaxContinuoslyLimit2"
                                Display="None" ValidationGroup="a" ErrorMessage="Max Continuosly Limit" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Leave Start After
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtLeaveApplicable" runat="server" CssClass="requiredField" TabIndex="12" ToolTip="Enter Leave Start After"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="txtMaxContinuoslyLimit0_FilteredTextBoxExtender"
                                runat="Server" TargetControlID="txtLeaveApplicable" FilterType="Custom,Numbers"
                                FilterMode="ValidChars" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-2">
                            <asp:DropDownList ID="ddlApplicableType" runat="server" Width="74px" TabIndex="13"
                                ToolTip="Select Leave Start After">
                                <asp:ListItem Selected="True">Day</asp:ListItem>
                                <asp:ListItem>Month</asp:ListItem>
                                <asp:ListItem>Year</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="reqLeaveApp" runat="server" ControlToValidate="txtLeaveApplicable"
                                Display="None" ValidationGroup="a" ErrorMessage="Please Enter Leave Start After"
                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Gap
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtGape" runat="server" CssClass="requiredField" TabIndex="14" ToolTip="Enter Gape">0</asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtGape"
                                FilterType="Numbers" FilterMode="ValidChars" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RequiredFieldValidator ID="reqGape" runat="server" ControlToValidate="txtGape"
                                Display="None" ValidationGroup="a" ErrorMessage="Please Enter Gape" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Accumulated
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlAccumulated" runat="server" TabIndex="15" ToolTip="Select Accumulated">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Encashed
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlEncashed" runat="server" TabIndex="16" ToolTip="Select Encashed">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Paid Leave
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlPaidLeave" runat="server" TabIndex="17" ToolTip="Select Paid Leave">
                                <asp:ListItem Text="Yes" Value="1" Selected="True" />
                                <asp:ListItem Text="No" Value="0" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Serial No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtSrNo" Text="1" runat="server" CssClass="requiredField" TabIndex="18" ToolTip="S. No."></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="Server" TargetControlID="txtSrNo"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RequiredFieldValidator ID="reqSNo" runat="server" ControlToValidate="txtSrNo"
                                Display="None" ValidationGroup="a" ErrorMessage="Enter Serial No. " SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Is Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="rbtnActive" runat="server" RepeatDirection="Horizontal"
                                TabIndex="19">
                                <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">Deactive</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" align="center">
                <asp:Button ID="btnUpdate" runat="server" CssClass="ItDoseButton" OnClick="btnUpdate_Click1"
                    Text="Update" Visible="false" ValidationGroup="a" TabIndex="21" ToolTip="Click to Update" Style="margin-top: 7px; width: 100px;" />
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSaveRecord_Click"
                    Text="Save" TabIndex="20" OnClientClick="return displayValidationResult();" ValidationGroup="a"
                    ToolTip="Click to Save" Style="margin-top: 7px; width: 100px;" />
                <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" OnClick="btnCancel_Click"
                    Text="Cancel" ValidationGroup="a" Visible="False" TabIndex="22" ToolTip="Click to Cancel" Style="margin-top: 7px; width: 100px;" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Leave List
            </div>
            <div class="row" align="center">
                <asp:GridView ID="grdLeave" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowCommand="grdLedgerName_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Name" HeaderText="Leave Name" ItemStyle-CssClass="GridViewLabItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="Grade" HeaderText="Grade" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="140px" />
                        <asp:BoundField DataField="NoOfLeave" HeaderText="No.Of Leave" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="Experience_From" HeaderText="Exp. From" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="Experience_To" HeaderText="Exp. To" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="MinLimit" HeaderText="Min.Limit" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="IsActive" HeaderText="Active" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:CommandField ShowSelectButton="true" ButtonType="Image" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" SelectImageUrl="~/Images/edit.png" />
                    </Columns>
                </asp:GridView>

            </div>
        </div>
    </div>
    <div id="divAddLeave"   class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white;width:750px; height:140px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divAddLeave" aria-hidden="true" onclick="closeEditGRN()">&times;</button>
                    <h4 class="modal-title">Create Leave</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24" align="center">
                            <asp:Label ID="lblLeaveError" CssClass="ItDoseLblError" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Leave Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                           <asp:TextBox ID="txtLeaveName" ClientIDMode="Static" runat="server" ValidationGroup="AddLeave" CssClass="requiredField" MaxLength="50" AutoCompleteType="Disabled"></asp:TextBox>
                        </div>
                        <div class="col-md-5">
                            <label class="pull-left">Leave Description</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                           <asp:TextBox ID="txtLeaveDescription" ClientIDMode="Static" runat="server" ValidationGroup="AddLeave"
                            CssClass="requiredField" MaxLength="200" AutoCompleteType="Disabled" TextMode="MultiLine">
                        </asp:TextBox></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnLeaveSave" OnClick="btnLeaveSave_Click" ClientIDMode="Static"
                            runat="server" CssClass="ItDoseButton" Text="Save" CausesValidation="false" OnClientClick="return validateLeave()" />
                    &nbsp;<input type="button" value="Cancel" class="ItDoseButton close" data-dismiss="divAddLeave" />
                            
                    </div>
                </div>
            </div>
        </div>
     <script>
         $(document).ready(function () {
             $('#btnLeave').click(function () {
                 $('#divAddLeave').showModel();
             });


         });
    </script>
</asp:Content>
