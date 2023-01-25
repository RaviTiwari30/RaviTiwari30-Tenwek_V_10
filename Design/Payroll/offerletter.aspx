<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="offerletter.aspx.cs" Inherits="Design_Payroll_offerletter" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
    </script>

    <script type="text/javascript">

        function validatespace() {
            var card = $('#<%=txtName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblmsg.ClientID %>').text('');
                return true;
            }

        }
        function check(sender, e) {
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
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;

            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));

                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
                if ((charCode == 44)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == ',');
                        if (hasDec)
                            return false;
                    }
                }
            }
            var card = $('#<%=txtName.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }

            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "43") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "37") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }

        function validate() {

            if ($.trim($("#<%=txtName.ClientID %>").val()) == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Employee Name');
                $("#<%=txtName.ClientID %>").focus();
                return false;
            }
            if ($.trim($("#<%=txtDesignation.ClientID %>").val()) == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Designation');
                $("#<%=txtDesignation.ClientID %>").focus();
                return false;
            }
            var OfferDate = $("#<%=txtOfferDate.ClientID %>").val();
            var JoinDate = $("#<%=txtJoinDate.ClientID %>").val();
            var splitdate1 = OfferDate.split("-");
            var dt11 = splitdate1[1] + " " + splitdate1[0] + ", " + splitdate1[2];
            var splitdate11 = JoinDate.split("-");
            var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];

            var newStartDate1 = Date.parse(dt11);
            var newEndDate1 = Date.parse(dt21);
            if ($("#<%=txtJoinDate.ClientID %>").val() != "") {
                if (newStartDate1 > newEndDate1) {
                    $("#<%=lblmsg.ClientID %>").text('Date of joining should be greater than or equal to offer date');

                    return false;
                }
            }
            if ($.trim($("#<%=txtEarning.ClientID %>").val()) == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Salary');
                $("#<%=txtEarning.ClientID %>").focus();
                return false;
            }
            if ($.trim($("#<%=txtOthBenefits.ClientID %>").val()) == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Other Benefits');
                $("#<%=txtOthBenefits.ClientID %>").focus();
                return false;
            }
            if ($.trim($("#<%=txtJoinTime.ClientID %>").val()) == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Join Time');
                $("#<%=txtJoinTime.ClientID %>").focus();
                return false;
            }
            if ($.trim($("#<%=txtLocation.ClientID %>").val()) == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Join Location');
                $("#<%=txtLocation.ClientID %>").focus();
                return false;
            }
            if ($.trim($("#<%=txtAuthorityName.ClientID %>").val()) == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Authority Name');
                $("#<%=txtAuthorityName.ClientID %>").focus();
                return false;
            }

            var masTime = document.getElementById("<%=maskTime.ClientID%>");
            var LblName = document.getElementById("<%=lblmsg.ClientID%>");
            ValidatorValidate(masTime);
            if (!masTime.isvalid) {
                LblName.innerText = masTime.errormessage;
                return false;
            }
            else {
                $("#<%=lblmsg.ClientID %>").text('');
            }
        }
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
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Offer Letter </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Employee Details
            </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled" MaxLength="100" TabIndex="1" ToolTip="Enter Employee Name" onkeypress="return check(this,event)"
                                    onkeyup="validatespace();" CssClass="requiredField"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Designation
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtDesignation" TabIndex="2" AutoCompleteType="Disabled" ToolTip="Enter Designation"
                                    runat="server" MaxLength="50" CssClass="requiredField"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    P.O. Box Address
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtPOBoxAddress" runat="server" AutoCompleteType="Disabled" MaxLength="100" TabIndex="3" ToolTip="Enter P.O. Box Address"
                                    onkeyup="validatespace();" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Offer Letter Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtOfferDate" runat="server" TabIndex="4" ToolTip="Select  Offer Letter Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="calOfferDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtOfferDate">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Joining Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtJoinDate" runat="server" ClientIDMode="Static"
                                    TabIndex="5" ToolTip="Select Joining Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="calJoinDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtJoinDate">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Joining Time
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtJoinTime" runat="server" MaxLength="10" TabIndex="6"
                                    ToolTip="Enter Join Time" CssClass="requiredField"></asp:TextBox>
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                                <cc1:MaskedEditExtender ID="masTime" runat="server" TargetControlID="txtjointime"
                                    MaskType="Time" AcceptAMPM="true" Mask="99:99">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtJoinTime"
                                    ControlExtender="masTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="v1"></cc1:MaskedEditValidator>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Salary
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                 <asp:TextBox ID="txtEarning" runat="server" MaxLength="10" TabIndex="7"
                                ToolTip="Enter Salary" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)" CssClass="requiredField"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" Enabled="True"
                                FilterType="Custom, numbers" ValidChars="." TargetControlID="txtEarning">
                            </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Other Benefits
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtOthBenefits" runat="server" MaxLength="10" TabIndex="8"
                                ToolTip="Enter Other Benefits" AutoCompleteType="Disabled"
                                onkeypress="return checkForSecondDecimal(this,event)" CssClass="requiredField"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbOther"
                                runat="server" Enabled="True"
                                FilterType="Custom, numbers" ValidChars="." TargetControlID="txtOthBenefits">
                            </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Join Location
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtLocation" runat="server" AutoCompleteType="Disabled" ToolTip="Enter Join Location"
                                TabIndex="9" MaxLength="50" onkeypress="return check(this,event)" CssClass="requiredField"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                  <label class="pull-left">
                                    Job Timing
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                 <asp:TextBox ID="txtTiming" runat="server" MaxLength="10" TabIndex="9"
                                ToolTip="Enter Job Timing"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                  <label class="pull-left">
                                    Authority Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtAuthorityName" AutoCompleteType="Disabled" runat="server" MaxLength="100" ToolTip="Enter Authority Name" TabIndex="11" onkeypress="return check(this,event)" CssClass="requiredField"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                  <label class="pull-left">
                                    Authority Designation
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtAuthorityDesignation" runat="server" MaxLength="50"
                                ToolTip="Enter Authority Designation" AutoCompleteType="Disabled" TabIndex="12"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Authority Department
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtAuthorityDepartment" runat="server" MaxLength="50"
                                TabIndex="13" ToolTip="Enter Authority Department" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            </div>
                        
                        </div>
                    </div>
                </div>
           
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" ValidationGroup="v1"
                    CssClass="ItDoseButton" ToolTip="Click to Save" TabIndex="13" OnClientClick="return validate();" style="margin-top:7px; width:100px" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click"
                    CssClass="ItDoseButton" ValidationGroup="v1" ToolTip="Click to Update" TabIndex="13"
                    OnClientClick="return validate();" style="margin-top:7px; width:100px" />
                <asp:Button ID="btncancel" ToolTip="Click to Save" TabIndex="14" runat="server" Text="Cancel"
                    OnClick="btncancel_Click" CssClass="ItDoseButton" style="margin-top:7px; width:100px" />
            </div>
        </div>
</asp:Content>
