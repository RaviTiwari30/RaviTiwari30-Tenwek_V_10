<%@ Page Language="C#" MaintainScrollPositionOnPostback="true" MasterPageFile="~/DefaultHome.master"
    AutoEventWireup="true" CodeFile="EmployeeRegistration.aspx.cs" Inherits="Design_Employee_EmployeeRegistration" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    &nbsp;<script type="text/javascript">
              function SearchCheckboxem(textbox, cbl) {
                  if ($(textbox).val() != "") {
                      $("#<%=grlLoginRoles.ClientID%> tr").each(function () {
                         var chk  = $(this).closest("tr").find(cbl);
                          $(chk).children('tbody').children('tr').children('td').each(function () {
                              var match = false;
                              $(this).children('label').each(function () {
                                  if ($(this).text().toUpperCase().indexOf($(textbox).val().toUpperCase()) > -1)
                                      match = true;
                              });
                              if (match) {
                                  $(this).show();
                              }
                              else { $(this).hide(); }
                          });
                      });
                  }
                  else {
                      $("#<%=grlLoginRoles.ClientID%> tr").each(function () {
                          var chk = $(this).closest("tr").find(cbl);
                          $(chk).children('tbody').children('tr').children('td').each(function () {
                              $(this).show();
                          });
                      });
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
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || keychar == "0" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
        function validatespace() {
            var Pname = $('#<%=txName.ClientID %>').val();
            if (Pname.charAt(0) == ' ' || Pname.charAt(0) == '.' || Pname.charAt(0) == ',') {
                $('#<%=txName.ClientID %>').val('');
                $('#<%=lblErrmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                Pname.replace(Pname.charAt(0), "");
                return false;
            }

            else {
                return true;
            }

        }
        function validateSpaceFather() {
            var Father = $('#<%=txtFather.ClientID %>').val();
            if (Father.charAt(0) == ' ' || Father.charAt(0) == '.' || Father.charAt(0) == ',') {
                $('#<%=txtFather.ClientID %>').val('');
                $('#<%=lblErrmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                Pname.replace(Pname.charAt(0), "");
                return false;
            }

            else {
                return true;
            }
        }
        function validateSpaceMother() {
            var Father = $('#<%=txtFather.ClientID %>').val();
            if (Father.charAt(0) == ' ' || Father.charAt(0) == '.' || Father.charAt(0) == ',') {
                $('#<%=txtFather.ClientID %>').val('');
                $('#<%=lblErrmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                Pname.replace(Pname.charAt(0), "");
                return false;
            }

            else {
                return true;
            }
        }
        function email() {
            var emailaddress = $('#<%=txtEmail.ClientID %>').val();
            var emailexp = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

            if (!emailexp.test(emailaddress)) {
                alert('Please enter valid email address.');
                $('#<%=txtEmail.ClientID %>').focus();
                return false;
            }
            else {
                return true;
            }
        }
        $(document).ready(function () {
            $("#txtDOB").bind('keyup keydown', function (e) {

                var keycode = e.keyCode ? e.keyCode : e.which;
                var keynum;
                if (window.event) {
                    keynum = e.keyCode;
                }
                else if (e.which) {
                    keynum = e.which;
                }
                if (keycode == 8) { // backspace
                    $(this).val('');
                }
                else if (keycode == 46) { // delete
                    $(this).val('');
                }


            });
        });

        function validate() {
            if ($('#ctl00_ContentPlaceHolder1_Lbl_Helplabel').text() != "") {
                $("#<%=lblErrmsg.ClientID%>").text('Please Enter The ' + $('#ctl00_ContentPlaceHolder1_Lbl_Helplabel').text());
                $("#<%=txtpwd.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#txName").val()) == "") {
                $("#lblErrmsg").text('Please Enter Name');
                $("#txName").focus();
                return false;
            }
            if ($.trim($("#txtCity").val()) == "") {
                $("#lblErrmsg").text('Please Enter City');
                $("#txtCity").focus();
                return false;
            }
            if ($.trim($("#txtMobile").val()) == "") {
                $("#lblErrmsg").text('Please Enter Contact No.');
                $("#txtMobile").focus();
                return false;
            }
            if (($.trim($("#txtMobile").val()) != "") && ($.trim($("#txtMobile").val()).length < 10)) {
                $("#lblErrmsg").text('Please Enter Valid Contact No.');
                $("#txtMobile").focus();
                return false;
            }
            if ($('#ddlDepartment').val() == '0') {
                $("#lblErrmsg").text('Please Select Employee Department');
                $("#ddlDepartment").focus();
                return false;
            }
            if ($('#ddlDesignation').val() == '0') {
                $("#lblErrmsg").text('Please Select Employee Designation');
                $("#ddlDesignation").focus();
                return false;
            }
            if (Page_IsValid) {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            }

        }
        var checkUpdatePassword = function () {
            if ($('#cbUpdatePassword').prop('checked')) {
                $('#<%=txtuid.ClientID%>').removeAttr('disabled');
                $('#<%=txtpwd.ClientID%>').removeAttr('disabled');
                $('#<%=txtcpwd.ClientID%>').removeAttr('disabled');
            }
            else {
                $('#<%=txtuid.ClientID%>').attr('disabled', 'disabled');
                $('#<%=txtpwd.ClientID%>').attr('disabled', 'disabled');
                $('#<%=txtcpwd.ClientID%>').attr('disabled', 'disabled');
            }
        }
        $(document).ready(function () {
            checkUpdatePassword();
            AutoGender();
        });
        function AutoGender() {
            var ddltitle = document.getElementById('<%=cmdTitle.ClientID%>');
            var ddltxt = ddltitle.options[ddltitle.selectedIndex].text;
            if (ddltxt == "Mr." || ddltxt=="Mohd.") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: true });
                        $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr('disabled', true);
             }
              else if (ddltxt == "Mrs.") {
                        $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr({ checked: true, disabled: true });
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr('disabled', true);
            }
            else if (ddltxt == "Miss." || ddltxt == "Baby." || ddltxt == "Madam.") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr({ checked: true, disabled: true });
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr('disabled', true);
            }
            else if (ddltxt == "Master") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: true });
                $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr('disabled', true);
            }
            else if (ddltxt == "B/O.") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: false });
                $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr('disabled', false);
            }
            else if (ddltxt == "Dr.") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr('disabled', false);
                $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr('disabled', false);
                $('#<%=rbtnGender.ClientID%> :radio[value="TGender"]').attr('disabled', false);
            }
            else {
                $('#<%=rbtnGender.ClientID%>').attr('disabled', false);
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr('checked', true);
            }
         $('#<%=txtGender.ClientID %>').val($('#<%=rbtnGender.ClientID%> input:checked').val());
        }
    </script><div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Employee Registration</b><br />
            <asp:Label ID="lblErrmsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Employee Details&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>

                <div class="col-md-1"></div>
</div>


            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-10">
                            <label class="pull-left">
                                <asp:Label ID="lblID" runat="server" Width="30%" ForeColor="#0033CC"></asp:Label>
                            </label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Title
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmdTitle" runat="server" Width="" onchange="AutoGender();">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Full Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txName" runat="server" TabIndex="1" MaxLength="100" Width="95%"
                                ToolTip="Enter Name" ClientIDMode="Static" onkeypress="return check(event)" onkeyup="validatespace();" CssClass="requiredField"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqname" runat="server" SetFocusOnError="true" Display="None"
                                ControlToValidate="txName" ErrorMessage="Enter Name" ValidationGroup="save"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sex
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtnGender" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Text="Male" Value="Male"></asp:ListItem>
                                <asp:ListItem Value="Female" Text="Female"></asp:ListItem>
                                <asp:ListItem Value="TGender" Text="TGender"></asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:TextBox ID="txtGender" runat="server" Width="40" Style="display: none"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-10"></div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <strong>Local Address </strong>
                            </label>
                            <div class="col-md-11"></div>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                House No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtHouseNo" runat="server" Width="95%" TabIndex="2" MaxLength="35"
                                ToolTip="Enter House No." CssClass="requiredField"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqHouse" runat="server" SetFocusOnError="true" Display="None"
                                ControlToValidate="txtHouseNo" ErrorMessage="Enter House No." ValidationGroup="save"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Street No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtStreet" runat="server" TabIndex="3" MaxLength="35"
                                ToolTip="Enter Street No." ></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Locality
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLocality" runat="server" Width="100%" TabIndex="4" MaxLength="35"
                                ToolTip="Enter Locality"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                City
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCity" runat="server" ClientIDMode="Static" Width="95%" TabIndex="5" MaxLength="35"
                                ToolTip="Enter city" CssClass="requiredField"></asp:TextBox>
                          
                            <asp:RequiredFieldValidator ID="reqCity" runat="server" SetFocusOnError="true" Display="None"
                                ControlToValidate="txtCity" ErrorMessage="Enter City" ValidationGroup="save"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Postal Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPinCode" runat="server" TabIndex="6" MaxLength="10"
                                ToolTip="Enter Pin code"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-10"></div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                <strong>Permanent Address </strong>
                            </label>
                            <div class="col-md-10"></div>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                House No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtOhouseNo" runat="server" TabIndex="7" MaxLength="35"
                                ToolTip="Enter House No"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Street No 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtOStreet" runat="server" TabIndex="8" MaxLength="35"
                                ToolTip="Enter Street Name "></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Locality
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtOlocality" runat="server" TabIndex="9" MaxLength="35"
                                ToolTip="Enter Locality"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                City
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtOCity" runat="server" TabIndex="10" MaxLength="35"
                                ToolTip="Enter City"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Postal code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtOPinCode" runat="server" TabIndex="11" MaxLength="10" ToolTip="Enter Pin code"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbtxtOPinCode" TargetControlID="txtOPinCode" runat="server"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Email
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmail" runat="server" TabIndex="12" ToolTip="Enter E-Mail Address"
                                MaxLength="30"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="revEmail" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                runat="server" Display="None" ControlToValidate="txtEmail" ErrorMessage="Enter Valid Email Address"
                                ValidationGroup="save" SetFocusOnError="True"></asp:RegularExpressionValidator>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Contact No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMobile" Width="" ClientIDMode="Static" runat="server" MaxLength="15" TabIndex="15" CssClass="requiredField"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbtxtContactNoNo" FilterType="Numbers" runat="server" 
                                TargetControlID="txtMobile">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RequiredFieldValidator ID="reqContact" runat="server" ValidationGroup="save"
                                Display="None" ControlToValidate="txtMobile" SetFocusOnError="true" ErrorMessage="Error Contact No."></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="ReguExpress" runat="server" ControlToValidate="txtMobile"
                                Display="None" ErrorMessage="Contact No. Must be 10-15 Digit" SetFocusOnError="true"
                                ValidationExpression="^[0-9]{10,15}$" ValidationGroup="save"></asp:RegularExpressionValidator>
                        </div>
                        <div style="display: none;" class="col-md-3">
                            <asp:TextBox ID="txtSTD" runat="server" Width="46px" TabIndex="13" MaxLength="5"></asp:TextBox>
                            <asp:TextBox ID="txtPhone" runat="server" Width="41%" TabIndex="14" MaxLength="11"></asp:TextBox>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server" ToolTip="Select Department of Employee" CssClass="requiredField" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Designation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDesignation" runat="server" ToolTip="Select Designation of Employee" CssClass="requiredField" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Max Discount (%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                <asp:TextBox ID="txtDiscountPercent" onlynumber="5" decimalplace="4" max-value="100"  Width="" ClientIDMode="Static" runat="server" MaxLength="15" TabIndex="15" ></asp:TextBox>
                              
                            </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Personal Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Father's Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFather" runat="server" TabIndex="16" MaxLength="100"
                                ToolTip="Enter Father Name" onkeypress="return check(event)"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Mother's Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMother" runat="server" TabIndex="17" MaxLength="100"
                                ToolTip="Enter Mother Name" onkeypress="return check(event)"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Date of Birth 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDOB" runat="server" ToolTip="Select Date DOB" MaxLength="50"
                                TabIndex="18" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                            <cc1:CalendarExtender ID="calDob" runat="server" TargetControlID="txtDOB" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Qualification
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtqualification" runat="server" TabIndex="19" ToolTip="Enter Qualification"
                                MaxLength="35"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Passport No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPassport" runat="server" TabIndex="23" ToolTip="Enter Passport No."
                                MaxLength="35"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmgBloodGroup" runat="server" ToolTip="Select Blood Group"
                                TabIndex="25">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                User Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbUserType" runat="server" TabIndex="26">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                User Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlUserGroup" runat="server" TabIndex="26">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Start Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtStartTime" runat="server" ReadOnly="true" TabIndex="27"></asp:TextBox>
                            <cc1:CalendarExtender ID="calStartdate" runat="server" TargetControlID="txtStartTime"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

            <table border="0" style="width: 100%; border-collapse: collapse">
                <tbody>
                    <tr style="display: none">
                        <td style="width: 15%; text-align: right">Pan No. :&nbsp;
                        </td>
                        <td style="width: 35%; text-align: left">
                            <asp:TextBox ID="txtPAN" runat="server" Width="41%" TabIndex="22" ToolTip="Enter PAN No."
                                MaxLength="35"></asp:TextBox>
                        </td>
                        <td style="width: 15%; text-align: right">ESI Number ::&nbsp;
                        </td>
                        <td colspan="2" style="width: 35%; text-align: left">
                            <asp:TextBox ID="txtESI" runat="server" Width="41%" TabIndex="20" ToolTip="Enter ESI No. "
                                MaxLength="35"></asp:TextBox>

                        </td>
                    </tr>
                    <tr style="display: none">
                        <td style="width: 15%; text-align: right">Hospital :&nbsp;
                        </td>
                        <td style="width: 35%; text-align: left">
                            <asp:DropDownList ID="cmbHospital" runat="server" Width="43%" TabIndex="24">
                            </asp:DropDownList>
                        </td>
                        <td style="width: 15%; text-align: right; display: none">EPF Number :&nbsp;
                                
                        </td>
                        <td colspan="2" style="width: 35%; text-align: left; display: none">
                            <asp:TextBox ID="txtEPF" Width="41%" runat="server" TabIndex="21" ToolTip="Enter EPF No."
                                MaxLength="35"></asp:TextBox>
                        </td>

                    </tr>
                </tbody>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Login Details&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-8">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search By Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSearch" onkeyup="SearchCheckboxem(this,'#chk_prev')" autocomplete="off" data-title="Search Department Name" />
                        </div>
                        <div class="col-md-8">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                LoginType
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-20">
                            <asp:GridView ID="grlLoginRoles" runat="server" AutoGenerateColumns="False" ClientIDMode="Static"
                                CssClass="GridViewStyle"
                                TabIndex="10">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CentreName" HeaderText="Centre Name">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="80px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Roles">
                                        <ItemTemplate>
                                            <asp:Label ID="lblCentreId" runat="server" Text='<%#Eval("CentreID") %>' Visible="false"></asp:Label>
                                            <asp:CheckBoxList ID="chk_prev" runat="server" RepeatLayout="Table" RepeatDirection="Horizontal" ClientIDMode="Static"
                                                RepeatColumns="4" TabIndex="27">
                                            </asp:CheckBoxList>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="840px" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>

                    </div>
                     <div class="row"></div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UserName
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtuid" runat="server" Font-Bold="true" MaxLength="30" TabIndex="29" CssClass="requiredField"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Password
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtpwd" runat="server" Font-Bold="true" TextMode="Password" 
                                TabIndex="30" MaxLength="20" CssClass="requiredField"></asp:TextBox>
                            <asp:Label ID="TextBox1_HelpLabel" runat="server" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Confirm Password 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcpwd" runat="server" Font-Bold="true" TextMode="Password" TabIndex="31" MaxLength="20" CssClass="requiredField"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row">
                <div class="col-md-24" style="text-align:center">
                   <asp:Label ID="Lbl_Helplabel" runat="server" Font-Bold="true" BackColor="Yellow" ForeColor="Red" /></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:CheckBox ID="cbUpdatePassword" runat="server" ClientIDMode="Static" Text="Update Password" onclick="checkUpdatePassword()" />&nbsp;
            <asp:Label ID="lblOldUserName" runat="server" ClientIDMode="Static" Visible="false"></asp:Label>
            <asp:Label ID="lblOldPassword" runat="server" ClientIDMode="Static" Visible="false"></asp:Label>
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" TabIndex="32"
                ValidationGroup="save" CssClass="ItDoseButton" OnClientClick="return validate();" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" TabIndex="33"
                OnClick="btnClear_Click1" CssClass="ItDoseButton" />
            <asp:ValidationSummary ID="ValidationSummary1" ValidationGroup="save" runat="server"
                ShowMessageBox="True" ShowSummary="False" />
        </div>
    </div>
    <cc1:PasswordStrength ID="PasswordStrength1" runat="server" TargetControlID="txtpwd" ValidateRequestMode="Disabled" 
                DisplayPosition="AboveLeft"
                StrengthIndicatorType="Text"
                PreferredPasswordLength="6"
                PrefixText="Strength: "
                TextCssClass="TextIndicator_TextBox3"
                HelpStatusLabelID="Lbl_Helplabel"
                TextStrengthDescriptions="VeryPoor;Weak;Average;Strong;Excellent"
                TextStrengthDescriptionStyles="VeryPoor;Weak;Average;Excellent;Strong"
                MinimumLowerCaseCharacters="0"
                MinimumUpperCaseCharacters="0"
                MinimumSymbolCharacters="0"
                RequiresUpperAndLowerCaseCharacters="false"
                BarBorderCssClass="border" 
                />
    <style type="text/css">
      .VeryPoor
       {
         background-color:red;
       color:white;
       font-weight:bold;
         }

          .Weak
        {
         background-color:orange;
         color:white;
       font-weight:bold;
         }

          .Average
         {
          background-color: #A52A2A;
          color:white;
       font-weight:bold;
         }
          .Excellent
         {
         background-color:yellow;
         color:white;
       font-weight:bold;
         }
          .Strong
         {
         background-color:green;
         color:white;
       font-weight:bold;
         }
          .border
         {
          border: medium solid #800000;
          width:500px;                
         }
      </style>
</asp:Content>
