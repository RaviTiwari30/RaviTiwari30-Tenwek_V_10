<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="NewPatientRegistration.aspx.cs" Inherits="Design_OPD_NewPatientRegistration"
    EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">

        document.onkeydown = checkKeycode
        function checkKeycode(e) {
            var keycode;
            if (window.event)
                keycode = window.event.keyCode;
            else if (e)
                keycode = e.which;
            if ($.browser.mozilla) {
                if (keycode == 116 || (e.ctrlKey && keycode == 82)) {
                    if (e.preventDefault) {
                        e.preventDefault();
                        e.stopPropagation();
                    }
                }
            }
            else if ($.browser.msie) {
                if (keycode == 116 || (window.event.ctrlKey && keycode == 82)) {
                    window.event.returnValue = false;
                    window.event.keyCode = 0;
                    window.status = "Refresh is disabled";
                }
            }
        }
    </script>
    <script type="text/javascript">
        $(function () {
            var App_ID = '<%=Util.GetString(Request.QueryString["App_ID"])%>';
            if (App_ID == "") {
                $('#<%=txtAge.ClientID %>').val('');
                $('#<%=txtDOB.ClientID %>').attr('disabled', false);
                $('#<%=txtAge.ClientID %>,#<%=ddlAge.ClientID %>').attr('disabled', true);
                $('#<%=ddlAge.ClientID%> option:nth-child(1)').prop('selected', '0');
                $('#spnDOB').show(); $('#spnAge').hide();
                AutoGender();
                showRelation();
                getCountry();
            }
        });
        $(function () {

            if ($('#<%=rdbInjury.ClientID %> input:checked').val() == "Yes")
                $(".a").show();
            if ($('#<%=rdblAutoRelatedInjury.ClientID %> input:checked').val() == "Yes")
                $(".b").show();
            if ($('#<%=rblInsurance.ClientID %> input:checked').val() == "Yes")
                $(".c").show();
            $("#<%=rdbInjury.ClientID %>").click(function () {
                var rblval = $('#<%=rdbInjury.ClientID %> input:checked').val()
                if (rblval == "Yes") {
                    $(".a").show();
                }
                else {
                    $('#<%=ucWorkRelatedInjury.ClientID %>').val('');
                    $(".a").hide();
                }
            });
            $("#<%=rdblAutoRelatedInjury.ClientID %>").click(function () {
                var rblval = $('#<%=rdblAutoRelatedInjury.ClientID %> input:checked').val()
                if (rblval == "Yes") {
                    $(".b").show();
                }
                else {
                    $('#<%=ucAutoRelatedInjury.ClientID %>').val('');
                    $(".b").hide();
                }
            });
            $("#<%=rblInsurance.ClientID %>").click(function () {
                var rblval = $('#<%=rblInsurance.ClientID %> input:checked').val()
                if (rblval == "Yes")
                    $(".c").show();
                else
                    $(".c").hide();
            });
            if ('<%=Request.QueryString["App_ID"]%>' != "")
                $('#<%=txtPostalAddress.ClientID %>').focus();
            else
                $('#<%=txtPatientFirstName.ClientID %>').focus();

            var MaxLength = 100;
            $("#<% =txtPostalAddress.ClientID %>,#<%=txtEmergencyAddress.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtPostalAddress.ClientID%>').keypress(function (e) {
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
            $('#<%=txtPostalAddress.ClientID%>,#<%=txtEmergencyAddress.ClientID %>').keypress(function (e) {
                var keynum = "";
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
            AppID();
            $("#<%=rdDOB.ClientID%>").click(function () {
                $('#<%=txtAge.ClientID %>').val('');
                $('#<%=txtDOB.ClientID %>').attr('disabled', false);
                $('#<%=txtAge.ClientID %>,#<%=ddlAge.ClientID %>').attr('disabled', true);
                $('#<%=ddlAge.ClientID%> option:nth-child(1)').prop('selected', '0');
                $('#spnDOB').show(); $('#spnAge').hide();
            });
            $("#<%=rdAge.ClientID%>").click(function () {
                $('#<%=txtDOB.ClientID %>').val('');
                $('#<%=txtDOB.ClientID %>').attr('disabled', true);
                $('#<%=txtAge.ClientID %>,#<%=ddlAge.ClientID %>').attr('disabled', false);
                $('#spnDOB').hide(); $('#spnAge').show();
            });

            $('#<%=txtAge.ClientID %>').keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {

                    return false;
                }
                strLen = $(this).val().length;
                strVal = $(this).val();
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
            });
        });
        function AppID() {
            AppID = '<%=Util.GetString(Request.QueryString["App_ID"])%>';
            if (AppID != "") {
                if ($('#<%=rdDOB.ClientID %>').is(':checked')) {
                    $('#<%=txtDOB.ClientID %>,#<%=ddlAge.ClientID %>').attr('disabled', false);
                    $('#<%=txtAge.ClientID %>').attr('disabled', true);
                }
                if ($('#<%=rdAge.ClientID %>').is(':checked')) {
                    $('#<%=txtDOB.ClientID %>').attr('disabled', true);
                    $('#<%=txtAge.ClientID %>,#<%=ddlAge.ClientID %>').attr('disabled', false);
                }

            }
        }

        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if ($(id).text().length > charlimit)
                $(id).text($(id).text().substring(0, charlimit));
            else
                $("#divmessage").html("");
        }


        function clearform() {
            $(':text, textarea').val('');
            $(".chk").find(':checkbox').prop('checked', '');
            $(".rad").find(':radio').prop('checked', 'No');
            $('select option:nth-child(1)').prop('selected', 'selected');

        }
        function email() {
            var emailaddress = $('#<%=txtEmailAddress.ClientID %>').val();
            var emailexp = /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {

                alert('Please enter valid email address.');
                $('#<%=txtEmailAddress.ClientID %>').val('');
                $('#<%=txtEmailAddress.ClientID %>').focus();
                return false;
            }
            else {
                return true;
            }
        }

        function AutoGender() {
            var ddltitle = document.getElementById('<%=cmbTitle.ClientID%>');
            var ddltxt = ddltitle.options[ddltitle.selectedIndex].text;
            if (ddltxt == "Mr." || ddltxt == "Master") {
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop({ checked: true, disabled: true });
                 $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop({ checked: false, disabled: true });
             }
             else if (ddltxt == "Miss." || ddltxt == "Madam" || ddltxt == "Mrs.") {
                 $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop({ checked: true, disabled: true });
                    $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop({ checked: false, disabled: true });
                }
                else if (ddltxt == "Baby") {
                    $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop({ checked: false, disabled: false });
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop({ checked: true, disabled: false });
            }
            else if (ddltxt == "B/O") {
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop({ checked: true, disabled: false });
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop({ checked: false, disabled: false });
            }
            else if (ddltxt == "Dr." || ddltxt == "Er." || ddltxt == "Nana" || ddltxt == "Alhaji" || ddltxt == "Hajia" || ddltxt == "Prof.") {
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop({ checked: true, disabled: false });
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop({ checked: false, disabled: false });
            }
            else {
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop({ checked: true, disabled: false });
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop({ checked: false, disabled: false });
            }
    if (ddltxt == "B/O") {
        $('#ddlAge').prop("selectedIndex", 2);
        $("#ddlAge option[value='YRS']").attr("disabled", true);
        $("#ddlAge option[value='MONTH(S)'],#ddlAge option[value='DAYS(S)']").attr("disabled", false);
    }
    else if (ddltxt == "Baby" || ddltxt == 'Master') {
        $('#ddlAge').prop("selectedIndex", 1);
        $("#ddlAge option[value='YRS'],#ddlAge option[value='MONTH(S)'],#ddlAge option[value='DAYS(S)']").attr("disabled", false);
    }
    else {
        $('#ddlAge').prop("selectedIndex", 0);
        $("#ddlAge option[value='YRS']").attr("disabled", false);
        $("#ddlAge option[value='MONTH(S)'],#ddlAge option[value='DAYS(S)']").attr("disabled", true);
    }
}



function validatespace() {
    var Pname = $('#<%=txtPatientFirstName.ClientID %>').val();
    if (Pname.charAt(0) == ' ' || Pname.charAt(0) == '.' || Pname.charAt(0) == ',') {
        $('#<%=txtPatientFirstName.ClientID %>').val('');
        $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
        Pname.replace(Pname.charAt(0), "");
        return false;
    }
    else {
        $('#<%=lblMsg.ClientID %>').text('');
        return true;
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
    var Pname = $('#<%=txtPatientFirstName.ClientID %>').val();
    if (Pname.charAt(0) == ' ') {
        $('#<%=txtPatientFirstName.ClientID %>').val('');
        $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
        return false;
    }
    //List of special characters you want to restrict
    if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
        return false;
    }

    else {
        return true;
    }
}
function validateage() {
    var MaxValueYears = 161;
    var MaxValueDays = 32;
    var Age = $('#<%=ddlAge.ClientID %> :selected').val();
    var myLength = $('#<%=txtAge.ClientID %>').val();
    if (Age != "DAYS(S)") {
        $('#<%=txtAge.ClientID %> ').keyup(function (e) {
                    if ($('#<%=txtAge.ClientID %>').val().charAt(0) == "0") {
                        $('#<%=lblMsg.ClientID %>').text('0 is not allowed as first character');
                        $(this).val('');
                    }
                    if ($(this).val() >= MaxValueYears) {
                        $('#<%=lblMsg.ClientID %>').text('Please  Enter Valid Age');
                        $('#<%=txtAge.ClientID %>').val('');
                        $('#<%=txtAge.ClientID %>').focus();
                    }

                });
            }
            else {
                $('#<%=txtAge.ClientID %>').keyup(function (e) {
                    if ($('#<%=txtAge.ClientID %>').val().charAt(0) == "0") {
                        $('#<%=lblMsg.ClientID %>').text('0 is not allowed as first character');
                        $(this).val('');
                    }
                    if ($(this).val() >= MaxValueDays) {
                        $('#<%=lblMsg.ClientID %>').text('Please  Enter Valid Age');
                        $('#<%=txtAge.ClientID %>').val('');
                        $('#<%=txtAge.ClientID %>').focus();
                    }

                });

            }
            $('#<%=lblMsg.ClientID %>').text('');
}


    </script>
    <script type="text/javascript">
        function GetRate() {
            if ('<%=Resources.Resource.RegistrationChargeApplicable%>' == "1") {
                $.ajax({
                    url: "../Common/CommonService.asmx/bindLabInvestigationRate",
                    data: '{PanelID:"' + $('#ddlPanel').val().split('#')[1] + '",ItemID:"' + '<%=Resources.Resource.RegistrationItemID%>' + '",TID:"", IPDCaseTypeID: ""}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var obsData = jQuery.parseJSON(mydata.d);
                        if ((obsData != "") && (obsData != null)) {
                            $('#spnRate').text(obsData[0]["Rate"]);
                            $('#spnRateListID').text(obsData[0]["ID"]);
                        }
                        else {
                            $('#spnRate,#spnRateListID').text('0');
                        }
                    },
                    error: function (xhr, status) {
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                    }
                });
            }
            else {
                $('#spnRate,#spnRateListID').text('0');
            }
        }
        $(function () {
            GetRate();
        });
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Patient Registration Form</b><br />

            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
            <asp:TextBox ID="txtHash" CssClass="txtHash" Style="display: none;" runat="server"></asp:TextBox>
            <span id="spnErrorMsg"></span>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Personal Details<asp:Label ID="lblAppID" runat="server" Style="display: none"></asp:Label>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 18%; text-align: right">First Name :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:DropDownList ID="cmbTitle" runat="server" ToolTip="Select  Title" Width="55px"
                            TabIndex="1" onchange="AutoGender();" ClientIDMode="Static">
                        </asp:DropDownList>
                        <asp:TextBox ID="txtPatientFirstName" Width="144px" runat="server" AutoCompleteType="Disabled"
                            ToolTip="Enter First Name" TabIndex="2" ClientIDMode="Static" MaxLength="50" onkeypress="return check(event)"
                            onkeyup="validatespace();"></asp:TextBox>
                        <span style="color: red; font-size: 10px;" class="shat">*</span>
                    </td>
                    <td style="width: 18%; text-align: right">&nbsp; Last Name :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:TextBox ID="txtPatientLastName" runat="server" AutoCompleteType="Disabled" Width="144px"
                            TabIndex="3" ClientIDMode="Static" MaxLength="50" onkeypress="return check(event)"
                            onkeyup="validatespace();" ToolTip="Enter Last Name"> </asp:TextBox>
                        <span style="color: red; font-size: 10px; display: none" class="shat">*</span>
                    </td>

                </tr>
                <tr>
                    <td style="width: 18%; text-align: right; vertical-align: top">
                        <asp:RadioButton ID="rdDOB" runat="server" GroupName="A" Text="DOB :" Width="66px" Checked="true"
                            TabIndex="4" />&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <table style="width: 100%">
                            <tr>
                                <td style="width: 144px">
                                    <asp:TextBox ID="txtDOB" runat="server" Width="144px" TabIndex="5" ToolTip="Click To Select DOB"></asp:TextBox>

                                </td>

                                <td style="text-align: left">
                                    <asp:Label ID="spnDOB" ClientIDMode="Static" runat="server" Style="color: Red; font-size: 10px; display: none">*</asp:Label>
                                    <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="txtDOB" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                            </tr>
                        </table>

                    </td>
                    <td style="width: 18%; text-align: right; vertical-align: top">&nbsp;<asp:RadioButton ID="rdAge" runat="server" GroupName="A" Text="AGE :"
                        Width="66px" TabIndex="6" />&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <table style="width: 100%">
                            <tr>
                                <td style="width: 52px">
                                    <asp:TextBox ID="txtAge" runat="server" AutoCompleteType="Disabled" Width="52px"
                                        MaxLength="3" onkeyup="validateage();"
                                        ToolTip="Enter Age" TabIndex="7"></asp:TextBox>
                                </td>
                                <td style="width: 10px">
                                    <asp:Label ID="spnAge" ClientIDMode="Static" runat="server" Style="color: Red; font-size: 10px; display: none">*</asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlAge" runat="server" Width="76px" ClientIDMode="Static" TabIndex="8">
                                        <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                        <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                        <asp:ListItem Value="DAYS(S)">DAYS(S)</asp:ListItem>
                                    </asp:DropDownList>
                                    <cc1:FilteredTextBoxExtender ID="Fage" runat="Server" FilterType="Numbers,Custom"
                                        TargetControlID="txtAge" ValidChars=".">
                                    </cc1:FilteredTextBoxExtender>
                                </td>
                                <td>&nbsp;
                                </td>
                            </tr>
                        </table>



                    </td>

                </tr>
                <tr>
                    <td style="width: 18%; text-align: right">Sex :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:RadioButtonList ID="rblSex" runat="server" RepeatDirection="Horizontal"
                            ToolTip="Select Sex" TabIndex="9">
                            <asp:ListItem Value="Male" Text="Male" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="Female" Text="Female"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 18%; text-align: right">Marital Status :&nbsp
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:DropDownList ID="ddlMarital" ClientIDMode="Static" runat="server" TabIndex="10"
                            Width="150px" class="ddl" ToolTip="Select Martial Status">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="1">Married</asp:ListItem>
                            <asp:ListItem Value="2">Unmarried</asp:ListItem>
                        </asp:DropDownList>
                        <span style="color: red; font-size: 10px;" class="shat">*</span>
                    </td>

                </tr>
                <tr>
                    <td style="width: 18%; text-align: right">Contact No. :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:TextBox ID="txtTelephoneNo" Width="144px" ToolTip="Enter Contact No" runat="server" MaxLength="10"
                            TabIndex="11" AutoCompleteType="Disabled" onkeyup="showContactNoLength()" ClientIDMode="Static"></asp:TextBox>
                        <span style="color: red; font-size: 10px;" class="shat">*</span>
                        <cc1:FilteredTextBoxExtender ID="ftbTelephoneNo" runat="server" TargetControlID="txtTelephoneNo"
                            FilterType="Numbers">
                        </cc1:FilteredTextBoxExtender>
                        <span id="spnContactNoLength" style="font-weight: bold;"></span>
                    </td>
                    <td style="width: 18%; text-align: right">Email Address :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:TextBox ID="txtEmailAddress" runat="server" onblur="email(this);" Width="144px"
                            TabIndex="12" AutoCompleteType="Disabled" MaxLength="30" ToolTip="Enter Email Address"></asp:TextBox>
                    </td>

                </tr>
                <tr>
                    <td style="width: 18%; text-align: right">Relation Of :&nbsp;</td>
                    <td style="width: 32%; text-align: left">
                        <asp:DropDownList ID="ddlRelationOf" runat="server" onchange="showRelation()" TabIndex="13" Width="150px" ToolTip="Select Relation Of" ClientIDMode="Static"></asp:DropDownList>
                    </td>
                    <td style="width: 18%; text-align: right">Relation Name :&nbsp;</td>
                    <td style="width: 32%; text-align: left">
                        <asp:TextBox ID="txtRelationName" runat="server" Width="144px" onkeypress="return check(event)"
                            TabIndex="14" AutoCompleteType="Disabled" MaxLength="50" ToolTip="Enter Relation Name" ClientIDMode="Static"></asp:TextBox>
                        <asp:Label ID="lblRelation" ClientIDMode="Static" runat="server" Style="color: Red; font-size: 10px; display: none">*</asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 18%; text-align: right">Relation&nbsp;Contact&nbsp;No.&nbsp;:&nbsp;</td>
                    <td style="width: 32%; text-align: left">
                        <asp:TextBox ID="txtRelationContactNo" Width="144px" ToolTip="Enter Contact No" runat="server" MaxLength="10"
                            TabIndex="15" AutoCompleteType="Disabled" onkeyup="showRelContactNoLength()" ClientIDMode="Static"></asp:TextBox>
                        <span id="spnKinContactNoLength" style="font-weight: bold;"></span>
                        <cc1:FilteredTextBoxExtender ID="ftbRContactNo" runat="server" TargetControlID="txtRelationContactNo" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="width: 18%; text-align: right">Occupation :&nbsp;</td>
                    <td style="width: 32%; text-align: left">
                        <asp:TextBox ID="txtOccupation" runat="server" TabIndex="16" ToolTip="Enter Occupation" Width="144px" MaxLength="20"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width: 18%; text-align: right; vertical-align: top; height: 31px;" rowspan="1">Address :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left; height: 31px;" rowspan="1">
                        <asp:TextBox ID="txtPostalAddress" runat="server" TextMode="MultiLine" Width="290px"
                            TabIndex="17" Height="20px" MaxLength="200" ToolTip="Enter Postal Address"></asp:TextBox>
                        <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px; font-family: Verdana; display: none">*</asp:Label>

                    </td>
                    <td style="width: 18%; text-align: right; height: 31px;">&nbsp;</td>
                    <td style="text-align: left; width: 32%; height: 31px;">&nbsp;</td>

                </tr>
                <tr>
                    <td style="width: 18%; text-align: right; vertical-align: top;">Country :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left;">
                        <asp:DropDownList ID="ddlNationality" runat="server" TabIndex="18" ToolTip="Select Country"
                            onchange="getState()" Width="150px" ClientIDMode="Static">
                        </asp:DropDownList>

                    </td>
                    <td style="width: 18%; text-align: right;">State :&nbsp;</td>
                    <td style="text-align: left; width: 32%;">
                        <asp:DropDownList ID="ddlState" runat="server" TabIndex="19" ToolTip="Select State"
                            onchange="getDistrict()" Width="150px" ClientIDMode="Static">
                        </asp:DropDownList></td>

                </tr>
                <tr>
                    <td rowspan="1" style="width: 15%; text-align: right; vertical-align: top">District :&nbsp;
                    </td>
                    <td rowspan="1" style="width: 35%; text-align: left; vertical-align: top;">
                        <%--<asp:TextBox ID="txtDistrict" runat="server" ClientIDMode="Static" Width="144px" TabIndex="17" ></asp:TextBox>--%>
                        <asp:DropDownList ID="ddlDistrict" runat="server" TabIndex="20" ToolTip="Select District"
                            onchange="getcity()" Width="150px" ClientIDMode="Static">
                        </asp:DropDownList>
                        <asp:Button ID="btnDist" runat="server" CssClass="ItDoseButton"
                            Text="New" ToolTip="Click To Add New District" ClientIDMode="Static" />
                        <cc1:ModalPopupExtender ID="mpDistrict" runat="server" BackgroundCssClass="filterPupupBackground"
                            CancelControlID="btnDistCancel" DropShadow="true" PopupControlID="pnlDistrict"
                            TargetControlID="btnDist" OnCancelScript="CloseDistrict()" BehaviorID="mpDistrict">
                        </cc1:ModalPopupExtender>

                    </td>
                    <td style="width: 18%; text-align: right">City :&nbsp;</td>
                    <td style="text-align: left; width: 32%;">
                        <asp:DropDownList ID="ddlCity" runat="server" TabIndex="21" ToolTip="Select City"
                            Width="150px" ClientIDMode="Static">
                        </asp:DropDownList>
                        <asp:Button ID="btnNewCity" runat="server" CssClass="ItDoseButton"
                            Text="New" ToolTip="Click To Add New City" ClientIDMode="Static" />

                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right; vertical-align: top">Block :&nbsp;<%--Taluka :&nbsp;--%></td>
                    <td style="width: 32%; text-align: left" rowspan="1">
                        <asp:TextBox ID="txtLandMark" runat="server" ClientIDMode="Static" Width="144px" TabIndex="22" MaxLength="20" Style="display: none"></asp:TextBox>

                        <asp:DropDownList ID="ddlTaluka" runat="server" ClientIDMode="Static" TabIndex="19" ToolTip="Select Taluka"
                            Width="150px">
                        </asp:DropDownList>
                        <asp:Button ID="btnNewTaluka" runat="server" CssClass="ItDoseButton"
                            Text="New" ToolTip="Click To Add New Taluka" ClientIDMode="Static" />
                        <cc1:ModalPopupExtender ID="mpTaluka" runat="server" BackgroundCssClass="filterPupupBackground"
                            CancelControlID="btnTaluka" DropShadow="true" PopupControlID="pnlTaluka"
                            TargetControlID="btnNewTaluka" OnCancelScript="closeTaluka()" BehaviorID="mpTaluka">
                        </cc1:ModalPopupExtender>
                    </td>
                    <td rowspan="1" style="width: 15%; text-align: right; vertical-align: top">Place :&nbsp;
                    </td>
                    <td rowspan="1" style="width: 35%; text-align: left; vertical-align: top">
                        <asp:TextBox ID="txtPlace" runat="server" ClientIDMode="Static" TabIndex="23" MaxLength="20" Width="144px"></asp:TextBox>
                    </td>
                </tr>


                <tr>
                    <td style="width: 18%; text-align: right; vertical-align: top" rowspan="1">Adhar Card No. :&nbsp;</td>
                    <td style="text-align: left; width: 35%; vertical-align: top">

                        <asp:TextBox ID="txtAdharCardNo" runat="server" ClientIDMode="Static" Width="144px" MaxLength="12" TabIndex="24"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbAdharCardNo" runat="server" TargetControlID="txtAdharCardNo" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    </td>

                    <td style="width: 15%; text-align: right; vertical-align: top">PinCode :&nbsp;</td>
                    <td style="text-align: left; width: 35%; vertical-align: top">
                        <asp:TextBox ID="txtPinCode" runat="server" ClientIDMode="Static" MaxLength="6" TabIndex="25" Width="144px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbPinCode" runat="server" FilterType="Numbers" TargetControlID="txtPinCode">
                        </cc1:FilteredTextBoxExtender>
                        <span class="shat" style="color: red; font-size: 10px; display: none">*</span></td>
                </tr>





                <tr style="display: none">
                    <td style="width: 18%; text-align: right">Language Spoken :&nbsp;</td>
                    <td style="text-align: left; width: 32%;">
                        <asp:DropDownList ID="ddlLanguageSpoken" runat="server" ToolTip="Select Language Spoken" Width="150px">
                        </asp:DropDownList>
                        <asp:Label ID="lblsubcategoryID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                    </td>
                    <td style="width: 18%; text-align: right">Employer :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:TextBox ID="txtEmployer" runat="server" MaxLength="50" AutoCompleteType="Disabled"
                            ToolTip="Enter Employer" Width="144px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 18%; text-align: right">Panel :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:DropDownList ID="ddlPanel" runat="server" Width="150px" ToolTip="Select Panel" ClientIDMode="Static" onchange="GetRate()" TabIndex="26"></asp:DropDownList>
                        <asp:Label ID="lblReferPanelOPD" runat="server" Visible="true" ClientIDMode="Static" Style="display: none"></asp:Label>
                    </td>

                    <td style="width: 18%; text-align: right">Registration Fee  :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left;">

                        <span id="spnRate" style="font-weight: 700"></span>
                        <span id="spnRateListID" style="display: none"></span>
                        <span id="spnScheduleChargeID" style="display: none"></span>
                        <asp:Label ID="lblDoctorID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                        <asp:TextBox ID="txtReligiousAffiliation" runat="server" Width="144px" TabIndex="17"
                            MaxLength="50" AutoCompleteType="Disabled" ToolTip="Enter Religious Affiliation" Visible="false"></asp:TextBox>
                    </td>

                </tr>
                <tr style="display: none">
                    <td style="width: 18%; text-align: right">Place of Birth :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:DropDownList ID="ddlPlaceOfBirth" ToolTip="Select Place of Birth" runat="server" Width="150px" TabIndex="18"></asp:DropDownList>
                    </td>
                    <td style="width: 18%; text-align: right">Race/Ethnicity :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:DropDownList ID="ddlRace" runat="server" ToolTip="Select Race/Ethnicity" Width="150px">
                        </asp:DropDownList>

                    </td>

                </tr>
                <tr>
                    <td style="width: 15%; text-align: right; vertical-align: top"></td>
                    <td style="width: 35%; text-align: left; vertical-align: top">&nbsp;</td>
                    <td style="width: 15%; text-align: right; vertical-align: top">Patient Type :&nbsp;</td>
                    <td style="text-align: left; width: 35%; vertical-align: top">
                        <asp:DropDownList ID="ddlPatientType" runat="server" Width="148px" ClientIDMode="Static" TabIndex="27">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="SELF">SELF</asp:ListItem>
                            <asp:ListItem Value="INTERNET">INTERNET</asp:ListItem>
                            <asp:ListItem Value="Advertisement">Advertisement</asp:ListItem>
                            <asp:ListItem Value="Doctor Reffered">Doctor Reffered</asp:ListItem>
                            <asp:ListItem Value="Patient Suggested">Patient Suggested</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="display: none">
            <div class="Purchaseheader">
                Patient Emergency Details
            </div>
            <table style="border-collapse: collapse; width: 100%">
                <tr>
                    <td style="width: 18%; text-align: right">Emergency Notify :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="txtEmergencynotify" runat="server" TabIndex="21"
                            MaxLength="50" AutoCompleteType="Disabled" ToolTip="Enter Emergency Notify Name "></asp:TextBox>
                    </td>
                    <td style="width: 18%; text-align: right">Relationship :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:DropDownList ID="ddlRelationShip" runat="server" TabIndex="22" ToolTip="Select Relationsihip"
                            Width="150px" Height="16px" ClientIDMode="Static">
                        </asp:DropDownList>
                    </td>

                </tr>
                <tr>
                    <td style="width: 18%; text-align: right; vertical-align: top" rowspan="2">Emergency&nbsp;Address&nbsp;:&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left" rowspan="2">
                        <asp:TextBox ID="txtEmergencyAddress" runat="server" TextMode="MultiLine" Width="290px"
                            TabIndex="23" Height="40px" MaxLength="50" AutoCompleteType="Disabled" ToolTip="Enter Emergency Contact Address"></asp:TextBox>
                    </td>
                    <td style="width: 18%; text-align: right; vertical-align: top">&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left; vertical-align: top">&nbsp;

                        
                    </td>

                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="display: none">
            <div class="Purchaseheader">
                Patient Other Details
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 18%; text-align: right">Purpose Of Visit :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">

                        <asp:DropDownList ID="ddlPurposeOfVisit" runat="server" ToolTip="Select Purpose Of Visit"
                            Width="150px" TabIndex="22">
                        </asp:DropDownList>

                    </td>
                    <td style="width: 18%; text-align: right">&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 18%; text-align: right">Name Of Your Physician :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:DropDownList ID="ddlPhysician" runat="server" TabIndex="23" ToolTip="Select Physician Name"
                            Width="150px">
                        </asp:DropDownList>

                    </td>
                    <td style="width: 18%; text-align: right">&nbsp;
                    </td>

                </tr>
                <tr>
                    <td style="width: 18%; text-align: right">Was This Work Related Injury ? :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:RadioButtonList ID="rdbInjury" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="Yes" Text="Yes"></asp:ListItem>
                            <asp:ListItem Value="No" Text="No" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 18%; display: none; text-align: right" class="a">Injury Date :&nbsp;
                    </td>
                    <td style="width: 32%; display: none; text-align: left" class="a">
                        <asp:TextBox ID="ucWorkRelatedInjury" runat="server" ToolTip="Click To Select Injury Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="calWorkRelatedInjury" runat="server" TargetControlID="ucWorkRelatedInjury"
                            Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 18%; text-align: right">Was This Auto Related Injury ? :&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left">
                        <asp:RadioButtonList ID="rdblAutoRelatedInjury" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="Yes" Text="Yes"></asp:ListItem>
                            <asp:ListItem Value="No" Text="No" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 18%; display: none; text-align: right" class="b">Injury Date :&nbsp;
                    </td>
                    <td style="width: 32%; display: none; text-align: left" class="b">
                        <asp:TextBox ID="ucAutoRelatedInjury" runat="server" ToolTip="Click To Select Injury Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="calucAutoRelatedInjury" runat="server" TargetControlID="ucAutoRelatedInjury"
                            Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right" colspan="2">Do you have a medical Insurance Covered by your Employer?&nbsp;
                    </td>
                    <td style="width: 32%; text-align: right">
                        <asp:RadioButtonList ID="rblInsurance" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="Yes" Text="Yes"></asp:ListItem>
                            <asp:ListItem Value="No" Text="No" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 36%; text-align: left">&nbsp;
                    </td>
                </tr>
                <tr style="display: none" class="c">
                    <td style="text-align: right" colspan="2">Name of company Medical Representative :&nbsp;
                    </td>
                    <td style="text-align: right; width: 10%">
                        <asp:TextBox ID="txtMedicalRepresentive" runat="server" MaxLength="50" AutoCompleteType="Disabled"
                            ToolTip="Enter Medical Representative Name"></asp:TextBox>
                    </td>
                    <td style="width: 36%; text-align: left">&nbsp;
                    </td>
                </tr>
                <tr style="display: none" class="c">
                    <td style="text-align: right" colspan="2">Patient or Legal Representative&#39;s Signature :&nbsp;&nbsp;
                    </td>
                    <td style="width: 10%; text-align: right">
                        <asp:TextBox ID="txtLegalRepresenative" runat="server" MaxLength="50" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td style="width: 36%; text-align: left">Date :
                      
                        <asp:TextBox ID="ucLegalRepresenative" runat="server" ToolTip="Click To Select Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="calLegalRepresenative" runat="server" TargetControlID="ucLegalRepresenative"
                            Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 22%; text-align: right"></td>
                    <td style="width: 35%; text-align: left"></td>
                    <td style="width: 10%; text-align: right"></td>
                    <td style="width: 36%; text-align: left"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <input type="checkbox" id="chkPrintSticker" checked="checked" style="display: none" />
            <input type="checkbox" id="chkOldPatient" />Old Patient
            <input type="button" value="Save" id="btnSaveReg" tabindex="28" class="ItDoseButton" onclick="saveReg()" />



        </div>
    </div>

    <asp:Panel ID="pnlCity" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="320px">
        <div class="Purchaseheader">
            Create City&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp; <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeCity()" />
                    to close</span></em>
        </div>

        <table style="width: 100%">
            <tr>
                <td colspan="2" style="text-align: center">
                    <span id="spnCity" class="ItDoseLblError"></span>
                </td>
            </tr>
            <tr>
                <td style="width: 30%; text-align: right">City :&nbsp;
                </td>
                <td style="width: 70%; text-align: left">
                    <input type="text" id="txtNewCity" maxlength="20" title="Enter City" />
                    <span style="color: red; font-size: 10px;">*</span>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="width: 100%; text-align: center">
                    <input type="button" onclick="saveNewCity();" tabindex="25" value="Save" class="ItDoseButton" id="btnSaveCity" title="Click To Save" />
                    &nbsp;<asp:Button ID="btnRCancel" runat="server" TabIndex="26"
                        CssClass="ItDoseButton" Text="Cancel" />
                </td>
            </tr>
        </table>

    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpCity" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlCity" PopupDragHandleControlID="dragHandle"
        TargetControlID="btnNewCity" BehaviorID="mpCity">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlDistrict" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="370px">
        <div id="Div3" class="Purchaseheader" runat="server">
            Create New District&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" alt="" style="cursor: pointer" onclick="CloseDistrict()" />

                  to close</span></em>
        </div>

        <table style="width: 100%">
            <tr>
                <td colspan="2" style="text-align: center">
                    <span id="spnErrorDistrict" class="ItDoseLblError"></span>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">&nbsp;District :&nbsp;
                </td>
                <td>
                    <input type="text" id="txtDistrict" maxlength="20" title="Enter District" />
                    <span style="color: red; font-size: 10px;">*</span>

                </td>
            </tr>
            <tr>

                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="saveDistrict();" value="Save" class="ItDoseButton" id="btnSaveDist" title="Click To Save" />
                    &nbsp;
                                    <asp:Button ID="btnDistCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                </td>
            </tr>
            <tr style="display: none">
                <td colspan="2" style="text-align: center">
                    <asp:TextBox ID="TextBox1" ClientIDMode="Static" runat="server" Text="0" Style="display: none"></asp:TextBox>


                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="pnlTaluka" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="344px">
        <div id="Div4" class="Purchaseheader" runat="server">
            Create New Taluka&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeTaluka()" />

                  to close</span></em>
        </div>
        <table style="width: 100%">
            <tr>
                <td colspan="2" style="text-align: center">
                    <span id="spnErrorTaluka" class="ItDoseLblError"></span>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">&nbsp;Taluka :&nbsp;
                </td>
                <td>
                    <input type="text" id="txtNewTaluka" maxlength="20" title="Enter Taluka" />
                    <span style="color: red; font-size: 10px;">*</span>

                </td>
            </tr>
            <tr>

                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="saveTaluka();" value="Save" class="ItDoseButton" id="btnSaveTaluka" title="Click To Save" />
                    &nbsp;
                                    <asp:Button ID="btnTaluka" runat="server" CssClass="ItDoseButton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                </td>
            </tr>

        </table>

    </asp:Panel>
    <script type="text/javascript">
        function validationReg() {
            var reg = 0;
            if ($.trim($("#<%=txtPatientFirstName.ClientID %>").val()) == "") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter First Name');
                $("#<%=txtPatientFirstName.ClientID %>").focus();
                return false;
            }

            //  if ($.trim($("#<%=txtPatientLastName.ClientID %>").val()) == "") {
            //      $('#<%=lblMsg.ClientID %>').text('Please Enter Last Name');
            //      $("#<%=txtPatientLastName.ClientID %>").focus();
            //      return false;
            //  }
            if ($('#<%=rdDOB.ClientID %>').is(':checked')) {
                if ($('#<%=txtDOB.ClientID %>').val().length == 0) {
                    $('#<%=lblMsg.ClientID %>').text('Please Enter DOB');
                    $('#<%=txtDOB.ClientID %>').focus();
                    return false;
                }
            }
            if ($('#<%=rdAge.ClientID %>').is(':checked')) {
                if ($('#<%=txtAge.ClientID %>').val().length == 0) {
                    $('#<%=lblMsg.ClientID %>').text('Please Enter Age');
                    $('#<%=txtAge.ClientID %>').focus();
                    return false;
                }
            }
            if ($("#<%=ddlMarital.ClientID %>").val() == "0") {
                $('#<%=lblMsg.ClientID %>').text('Please Select Marital Status');
                $("#<%=ddlMarital.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtTelephoneNo.ClientID %>").val().length == 0) {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Contact No');
                $("#<%=txtTelephoneNo.ClientID %>").focus();
                return false;

            }
            if ($("#<%=txtTelephoneNo.ClientID %>").val().length > 0) {
                if ($.trim($("#<%=txtTelephoneNo.ClientID %>").val()).length < "10") {
                    $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Contact No.');
                    $("#<%=txtTelephoneNo.ClientID %>").focus();
                    reg = 1;
                    return false;
                }
            }
            var emailaddress = $.trim($('#<%=txtEmailAddress.ClientID %>').val());
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Email Address');
                $('#<%=txtEmailAddress.ClientID %>').focus();
                reg = 1;
                return false;
            }
            if ($('#<%=ddlRelationOf.ClientID %>').val() != "0") {
                if ($.trim($('#<%=txtRelationName.ClientID %>').val()).length == 0) {
                    $('#<%=lblMsg.ClientID %>').text('Please Enter Relation Name');
                    $('#<%=txtRelationName.ClientID %>').focus();
                    return false;
                }
            }
            //  if ($.trim($("#<%=txtPostalAddress.ClientID %>").val()) == "") {
            //       $('#<%=lblMsg.ClientID %>').text('Please Enter Address');
            //        $("#<%=txtPostalAddress.ClientID %>").focus();
            //      return false;
            //    }
            if ($("#ddlDistrict").val() == "0") {
                $('#<%=lblMsg.ClientID %>').text('Please Select District');
                $("#ddlDistrict").focus();
                reg = 1;
                return false;
            }
            if ($("#<%=ddlCity.ClientID %> option:selected").text() == "---No Data Found---") {
                $('#<%=lblMsg.ClientID %>').text('Please Select City');
                $("#<%=ddlCity.ClientID %>").focus();
                reg = 1;
                return false;
            }
            if ($("#ddlTaluka").val() == "0") {
                $('#<%=lblMsg.ClientID %>').text('Please Select Block');
                $("#ddlTaluka").focus();
                reg = 1;
                return false;
            }

            //  if ($('#<%=txtPinCode.ClientID %>').val() == "") {
            //         $('#<%=lblMsg.ClientID %>').text('Please Enter Pin Code');
            //          $('#<%=txtPinCode.ClientID %>').focus();

            //    }

            if ($('#<%=rdbInjury.ClientID %> input:checked').val() == "Yes") {
                if ($('#<%=ucWorkRelatedInjury.ClientID %>').val() == "") {
                    $('#<%=lblMsg.ClientID %>').text('Please Enter Work Related Injury');
                    $('#<%=ucWorkRelatedInjury.ClientID %>').focus();
                    return false;

                }
            }
            if ($('#<%=rdblAutoRelatedInjury.ClientID %> input:checked').val() == "Yes") {
                if ($('#<%=ucAutoRelatedInjury.ClientID %>').val() == "") {
                    $('#<%=lblMsg.ClientID %>').text('Please Enter Auto Related Injury');
                    $('#<%=ucAutoRelatedInjury.ClientID %>').focus();
                    return false;
                }
            }
            if (reg == "0")
                return true;

        }
        function saveReg() {
            $('#btnSaveReg').attr('disabled', 'disabled').val("Submitting...");
            saveRegistration();
        }
        function enableControl() {
            $('#btnSaveReg').removeAttr('disabled').val("Save");

        }
        function PrintRegSticker(PatientID) {
            var ok = confirm("Do you Want to Print the Sticker");
            if (ok == true) {
                $.ajax({
                    url: "Services/PatientRegistration.asmx/PrintSticker",
                    data: '{PatientID:"' + PatientID + '"}',
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        Data = jQuery.parseJSON(result.d);
                        if (Data != "") {
                            window.location = 'barcode://?cmd=' + result.d + '&test=1&source=Barcode_Source_Registration';
                        }
                    },
                    error: function (xhr, status) {
                    }
                });
            }

        }
        function WriteToFiles(ddata, name) {
            try {

                var pdata = ddata;

                var Status = confirm(" You Want To Print The Sticker This Patient :" + pdata[0]["PatientID"]);
                if (Status == false)
                    return false;
                else {
                    if (name == "barcode") {
                        data = "SIZE 97.8 mm, 50.8 mm" + "\r\n";
                        data = data + "DIRECTION 0,0" + "\r\n";
                        data = data + "REFERENCE 0,0" + "\r\n";
                        data = data + "OFFSET 0 mm" + "\r\n";
                        data = data + "SET CUTTER OFF" + "\r\n";
                        data = data + "SET TEAR ON" + "\r\n";
                        data = data + "CLS" + "\r\n";
                        data = data + "CODEPAGE 1252" + "\r\n";
                        data = data + "TEXT 629,377,\"0\",180,13,11,\"" + pdata[0]["PatientID"] + "\"" + "\r\n";
                        data = data + "TEXT 629,338,\"ROMAN.TTF\",180,1,12,\"" + pdata[0]["Pname"] + "\"" + "\r\n";
                        data = data + "TEXT 629,276,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["Address"] + "\"" + "\r\n";
                        data = data + "TEXT 629,199,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["Place"] + "\"" + "\r\n";
                        data = data + "TEXT 375,181,\"ROMAN.TTF\",180,1,10,\"Age/Sex :\"" + "\r\n";
                        data = data + "TEXT 265,181,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["age"] + "/" + pdata[0]["gender"] + "\"" + "\r\n";
                        data = data + "TEXT 768,377,\"ROMAN.TTF\",180,1,10,\"MRD No    :\"" + "\r\n";
                        data = data + "TEXT 768,338,\"ROMAN.TTF\",180,1,10,\"Pat. Name :\"" + "\r\n";
                        data = data + "TEXT 768,145,\"ROMAN.TTF\",180,1,10,\"Phone     :\"" + "\r\n";
                        data = data + "TEXT 629,145,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["Mobile"] + "\"" + "\r\n";
                        data = data + "TEXT 768,181,\"ROMAN.TTF\",180,1,10,\"Reg. Date :\"" + "\r\n";
                        data = data + "TEXT 629,181,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["DateEnrolled"] + "\"" + "\r\n";
                        data = data + "TEXT 629,301,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["Relation"] + "\"" + "\r\n";
                        data = data + "TEXT 768,300,\"ROMAN.TTF\",180,1,10,\"Address    :\"" + "\r\n";
                        data = data + "BARCODE 629,115,\"39\",89,0,180,2,4,\"" + pdata[0]["PatientID"] + "\"" + "\r\n";
                        data = data + "PRINT 1,1" + "\r\n";
                    }
                    var fso = new ActiveXObject("Scripting.FileSystemObject");

                    if (name == "barcode") {
                        var s = fso.CreateTextFile("C:\\BarCode\\" + name + ".txt", true);
                        s.WriteLine(data);
                        s.Close();
                        var oShell = new ActiveXObject("Shell.Application");
                        var commandtoRun = "C:\\Barcode\\barcode.bat";
                        oShell.ShellExecute(commandtoRun, "", "", "open", "1");
                    }
                    else if (name == "S") {
                        s = fso.CreateTextFile("c:\\BarCode\\" + name + ".txt", true);
                        s.WriteLine(data);
                        s.Close();

                        var oShell = new ActiveXObject("Shell.Application");
                        var commandtoRun = "c:\\Barcode\\barcodes.bat";
                        oShell.ShellExecute(commandtoRun, "", "", "open", "1");
                    }
                }
            }
            catch (e) { }
        }
        function saveRegistration() {
            if (validationReg() == true) {
                var resultReg = registration();
                var rateListID = $('#spnRateListID').text();
                var DoctorID = $('#lblDoctorID').text();
                var SubCategoryID;
                if ($('#lblsubcategoryID').text() != "")
                    SubCategoryID = $('#lblsubcategoryID').text();
                else
                    SubCategoryID = "";
                var OldPatient;
                if ($('#chkOldPatient').is(":checked"))
                    OldPatient = 1;
                else
                    OldPatient = 0;
                $.ajax({
                    url: "Services/PatientRegistration.asmx/SaveReg",
                    data: JSON.stringify({ Data: resultReg, rateListID: rateListID, DoctorID: DoctorID, OldPatient: OldPatient, SubCategoryID: SubCategoryID }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    cache: false,
                    success: function (result) {
                        patientID = result.d;
                        if (patientID != "") {
                            if (patientID == "4")
                                $("#<%=lblMsg.ClientID%>").text('This action is already performed by another user for this Patient, Please Reopen page');
                            else if (patientID == "1")
                                $("#<%=lblMsg.ClientID%>").text('Patient Registration Charges & Hospital Charges are Rate Not Fix');
                            else if (patientID == "2")
                                $("#<%=lblMsg.ClientID%>").text('Patient Registration Charges are Rate Not Fix');
                            else if (patientID == "3")
                                $("#<%=lblMsg.ClientID%>").text('Patient Hospital Charges are Rate Not Fix');
                            else if (patientID == "0")
                                $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                            else {
                                $("#<%=lblMsg.ClientID%>").text('Record Saved Successfully');
                                alert('UHID :' + patientID.split('#')[0] + '');
                                if ('<%=Resources.Resource.RegistrationChargeApplicable%>' == "0") {
                                    enableControl();
                                    Clear();
                                }
                                else if ((patientID.split('#')[1] != "") && (patientID.split('#')[1] != "0")) {
                                    window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + patientID.split('#')[1] + '&IsBill=1&Duplicate=0');
                                    enableControl();
                                    Clear();
                                    if ($('#chkPrintSticker').is(":checked") && '<%=Resources.Resource.StickerPrinting_OPD_Lab_Phar_Doc_Diet.Split('#')[0]%>' == "1")
                                        PrintRegSticker(patientID.split('#')[0]);
                                }
                                else {
                                    var url = '<%=Util.GetString(Request.QueryString["url"])%>';
                                    var DoctorID = "";
                                    if (url != "") {
                                        location.href = 'GetPayment.aspx?url=' + url + '&App_ID=' + $('#<%=lblAppID.ClientID %>').text() + '&PatientID=' + patientID.split('#')[0] + '&DoctorID=' + DoctorID + '';
                                    }
                                }
                        }
    }
    else {
        $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                            enableControl();
                        }
                    },
                    error: function (xhr, status) {
                        $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');

                    }
                });
                }
                else {
                    enableControl();
                }

            }
            function registration() {
                var data = new Array();
                var objReg = new Object();
                objReg.Title = $("#<%=cmbTitle.ClientID %>").val();
            objReg.PFirstName = $.trim($("#<%=txtPatientFirstName.ClientID %>").val());
            objReg.PLastName = $.trim($("#<%=txtPatientLastName.ClientID %>").val());
            objReg.PName = $.trim($("#<%=txtPatientFirstName.ClientID %>").val()) + " " + $.trim($("#<%=txtPatientLastName.ClientID %>").val());
            if ($('#<%=rdDOB.ClientID %>').is(':checked')) {
                objReg.DOB = $.trim($('#<%=txtDOB.ClientID %>').val());
                objReg.Age = "";
            }
            else
                objReg.Age = $('#<%=txtAge.ClientID %>').val() + " " + $("#<%=ddlAge.ClientID%> option:selected").text();
            if ($("#<%=ddlPlaceOfBirth.ClientID %> option:selected").index() > 0)
                objReg.PlaceOfBirth = $("#<%=ddlPlaceOfBirth.ClientID %>").find('option:selected').text();
            else
                objReg.PlaceOfBirth = "";
            objReg.MaritalStatus = $("#<%=ddlMarital.ClientID %> option:selected").text();


            objReg.Gender = $("#<%=rblSex.ClientID%>").find(":checked").val();

            if ($.trim($("#<%=txtReligiousAffiliation.ClientID %> ").val()) != "")
                objReg.ReligiousAffiliation = $("#<%=txtReligiousAffiliation.ClientID %>").val();
            else
                objReg.ReligiousAffiliation = "";
            if ($("#<%=ddlLanguageSpoken.ClientID %> option:selected").index() > 0)
                objReg.LanguageSpoken = $("#<%=ddlLanguageSpoken.ClientID %> option:selected").text();
            else
                objReg.LanguageSpoken = "";

            objReg.Employer = $.trim($("#<%=txtEmployer.ClientID %>").val());
            objReg.EmergencyNotify = $.trim($("#<%=txtEmergencynotify.ClientID %>").val());
            if ($("#<%=ddlRelationShip.ClientID %> option:selected").index() > 0)
                objReg.EmergencyRelationShip = $("#<%=ddlRelationShip.ClientID %> option:selected").text();
            else
                objReg.EmergencyRelationShip = "";
            objReg.EmergencyAddress = $.trim($("#<%=txtEmergencyAddress.ClientID %>").val());
            objReg.EmergencyPhoneNo = $.trim($("#<%=txtRelationContactNo.ClientID %>").val());
            if ($("#<%=ddlRace.ClientID %> option:selected").index() > 0)
                objReg.Ethnicity = $("#<%=ddlRace.ClientID %> option:selected").text();
            else
                objReg.Ethnicity = "";
            objReg.App_ID = $('#<%=lblAppID.ClientID %>').text();

            objReg.PanelID = $('#ddlPanel').val().split('#')[0];

            objReg.Email = $.trim($("#<%=txtEmailAddress.ClientID %>").val());

            objReg.Mobile = $.trim($("#<%=txtTelephoneNo.ClientID %>").val());
            if ($('#<%=ddlRelationOf.ClientID %>').val() != "0")
                objReg.Relation = $('#<%=ddlRelationOf.ClientID %> option:selected').text();
            else
                objReg.Relation = "";
            objReg.House_No = $.trim($("#<%=txtPostalAddress.ClientID %>").val());
            objReg.RelationName = $.trim($('#<%=txtRelationName.ClientID %>').val());
            objReg.PatientType = $('#<%=ddlPatientType.ClientID %>').val();
            objReg.Country = $("#<%=ddlNationality.ClientID %> option:selected").text();
            objReg.District = $('#<%=ddlDistrict.ClientID %> option:selected').text();
            objReg.City = $("#<%=ddlCity.ClientID %> option:selected").text();
            objReg.Taluka = $("#<%=ddlTaluka.ClientID %> option:selected").text();
            objReg.CountryID = $("#<%=ddlNationality.ClientID %>").val();
            objReg.DistrictID = $('#<%=ddlDistrict.ClientID %>').val();
            objReg.CityID = $("#<%=ddlCity.ClientID %>").val();
            objReg.TalukaID = $("#<%=ddlTaluka.ClientID %>").val();
            objReg.Place = $.trim($('#<%=txtPlace.ClientID %>').val());
            objReg.LandMark = $.trim($('#<%=txtLandMark.ClientID %>').val());
            objReg.Occupation = $.trim($("#<%=txtOccupation.ClientID %>").val());
            objReg.Pincode = $.trim($('#<%=txtPinCode.ClientID %>').val());
            objReg.AdharCardNo = $.trim($('#<%=txtAdharCardNo.ClientID %>').val());
            if ($('#<%=ddlPatientType.ClientID %>').val() != "0")
                objReg.HospPatientType = $('#<%=ddlPatientType.ClientID %> option:selected').text();
            else
                objReg.HospPatientType = "";

            objReg.State = jQuery('#ddlState option:selected').text();
            objReg.StateID = jQuery('#ddlState').val();

            data.push(objReg);
            return data;

        }
        function Clear() {
            $("input[type=text], textarea").val('');
            $('#<%=lblAppID.ClientID %>').text('');
            $('#<%=lblReferPanelOPD.ClientID %>').text('');
            $('#ddlRelationOf,#ddlRelationShip,#ddlMarital,#cmbTitle').prop('selectedIndex', 0);
            $("#ddlPatientType").prop('selectedIndex', 0);
            $("#chkOldPatient").prop('checked', false);
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpCity')) {
                    cancelCity();
                }
                if ($find('mpTaluka')) {
                    closeTaluka();
                }
                if ($find('mpDistrict')) {
                    CloseDistrict();
                }
            }

        }
        function closeCity() {
            $("#txtNewCity").val('');
            $find('mpCity').hide();
            $("#spnCity").text("");
        }
        function cancelCity() {
            $("#txtNewCity").val('');
            $find('mpCity').hide();
            $("#spnCity").text('');
        }


        function showRelation() {
            if ($("#<%=ddlRelationOf.ClientID%> ").val() != "0") {
                $("#lblRelation").show();
                $("#txtRelationName").attr("readOnly", false);
            }
            else {
                $("#lblRelation").hide();
                $("#txtRelationName").attr("readOnly", true);
                $("#txtRelationName").val('');
            }
        }
        function WriteToFiles(ddata, name) {
            try {

                var pdata = ddata;

                var Status = confirm(" You Want To Print The Sticker This Patient :" + pdata[0]["PatientID"]);
                if (Status == false)
                    return false;
                else {
                    if (name == "barcode") {
                        data = "SIZE 97.8 mm, 50.8 mm" + "\r\n";
                        data = data + "DIRECTION 0,0" + "\r\n";
                        data = data + "REFERENCE 0,0" + "\r\n";
                        data = data + "OFFSET 0 mm" + "\r\n";
                        data = data + "SET CUTTER OFF" + "\r\n";
                        data = data + "SET TEAR ON" + "\r\n";
                        data = data + "CLS" + "\r\n";
                        data = data + "CODEPAGE 1252" + "\r\n";
                        data = data + "TEXT 629,377,\"0\",180,13,11,\"" + pdata[0]["PatientID"] + "\"" + "\r\n";
                        data = data + "TEXT 629,338,\"ROMAN.TTF\",180,1,12,\"" + pdata[0]["Pname"] + "\"" + "\r\n";
                        data = data + "TEXT 629,276,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["Address"] + "\"" + "\r\n";
                        data = data + "TEXT 629,199,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["Place"] + "\"" + "\r\n";
                        data = data + "TEXT 375,181,\"ROMAN.TTF\",180,1,10,\"Age/Sex :\"" + "\r\n";
                        data = data + "TEXT 265,181,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["age"] + "/" + pdata[0]["gender"] + "\"" + "\r\n";
                        data = data + "TEXT 768,377,\"ROMAN.TTF\",180,1,10,\"MRD No    :\"" + "\r\n";
                        data = data + "TEXT 768,338,\"ROMAN.TTF\",180,1,10,\"Pat. Name :\"" + "\r\n";
                        data = data + "TEXT 768,145,\"ROMAN.TTF\",180,1,10,\"Phone     :\"" + "\r\n";
                        data = data + "TEXT 629,145,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["Mobile"] + "\"" + "\r\n";
                        data = data + "TEXT 768,181,\"ROMAN.TTF\",180,1,10,\"Reg. Date :\"" + "\r\n";
                        data = data + "TEXT 629,181,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["DateEnrolled"] + "\"" + "\r\n";
                        data = data + "TEXT 629,301,\"ROMAN.TTF\",180,1,10,\"" + pdata[0]["Relation"] + "\"" + "\r\n";
                        data = data + "TEXT 768,300,\"ROMAN.TTF\",180,1,10,\"Address    :\"" + "\r\n";
                        data = data + "BARCODE 629,115,\"39\",89,0,180,2,4,\"" + pdata[0]["PatientID"] + "\"" + "\r\n";
                        data = data + "PRINT 1,1" + "\r\n";
                    }
                    var fso = new ActiveXObject("Scripting.FileSystemObject");

                    if (name == "barcode") {
                        var s = fso.CreateTextFile("C:\\BarCode\\" + name + ".txt", true);
                        s.WriteLine(data);
                        s.Close();
                        var oShell = new ActiveXObject("Shell.Application");
                        var commandtoRun = "C:\\Barcode\\barcode.bat";
                        oShell.ShellExecute(commandtoRun, "", "", "open", "1");
                    }
                    else if (name == "S") {
                        s = fso.CreateTextFile("c:\\BarCode\\" + name + ".txt", true);
                        s.WriteLine(data);
                        s.Close();

                        var oShell = new ActiveXObject("Shell.Application");
                        var commandtoRun = "c:\\Barcode\\barcodes.bat";
                        oShell.ShellExecute(commandtoRun, "", "", "open", "1");
                    }
                }
            }
            catch (e) { }
        }

    </script>
    <script type="text/javascript">
        function closeTaluka() {
            $find('mpTaluka').hide();
            $("#txtNewTaluka").val('');
            $("#spnErrorTaluka").text('');
        }
        function CloseDistrict() {
            $find('mpDistrict').hide();
            $("#txtDistrict").val('');
            $("#spnErrorDistrict").text('');
        }
    </script>
    <script type="text/javascript">
        function saveNewCity() {
            if ($.trim($("#txtNewCity").val()) != "") {
                $.ajax({
                    url: "../Common/CommonService.asmx/CityInsert",
                    data: '{ City: "' + $("#txtNewCity").val() + '", Country: "' + $("#<%=ddlNationality.ClientID %>").val() + '",DistrictID:"' + $("#ddlDistrict").val() + '",StateID:"' + jQuery("#ddlState").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        Data = (result.d);
                        if (Data == "0") {
                            $("#<%=lblMsg.ClientID%>").text('City Already Exist');
                            $("#txtNewCity").val('');
                        }
                        else if (Data > 0) {
                            $("#<%=lblMsg.ClientID%>").text('City Saved Successfully');
                            $("#<%=ddlCity.ClientID %>").append($("<option></option>").val(Data).html($("#txtNewCity").val()));
                            $("#<%=ddlCity.ClientID %>").val(Data);
                            $("#txtNewCity").val('');
                            $("#ddlCity option[value='0']").remove();
                        }
                        else {
                            $("#<%=lblMsg.ClientID%>").text('City Not Saved');

                        }
                        $find('mpCity').hide();
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        return false;
                    }
                });
        }
        else {
            $("#spnCity").text("Please Enter City Name");
            $("#txtNewCity").focus();

        }
    }
    function saveDistrict() {
        if ($.trim($("#txtDistrict").val()) != "") {
            $.ajax({
                url: "../Common/CommonService.asmx/DistrictInsert",
                data: '{District: "' + jQuery("#txtDistrict").val() + '",countryID:"' + jQuery("#ddlNationality").val() + '",stateID:"' + jQuery("#ddlState").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    District = (result.d);
                    if (District == "0")
                        $('#lblMsg').text('District Already Exist');
                    else if (District > 0) {
                        $('#lblMsg').text('District Saved Successfully');
                        $("#ddlDistrict").append($("<option></option>").val(District).html($("#txtDistrict").val()));
                        $("#ddlDistrict").val(District);
                        $("#ddlDistrict option[value='0']").remove();
                    }

                    else
                        $('#lblMsg').text('District Not Saved');


                    $("#txtDistrict").val('');
                    $find('mpDistrict').hide();

                    if ($("#ddlDistrict").length > 0)
                        $("#btnNewCity,#btnNewTaluka").removeAttr('disabled');
                    else
                        $("#btnNewCity,#btnNewTaluka").attr('disabled', 'disabled');
                },
            });
        }
        else {
            $('#spnErrorDistrict').text('Please Enter District');
            $("#txtDistrict").focus();
        }
    }
    function saveTaluka() {
        if ($.trim($("#ddlDistrict").val()) == "0") {
            $('#spnErrorTaluka').text('Please Select valid District');
            $("#ddlDistrict").focus();
            return;
        }
        if ($.trim($("#txtNewTaluka").val()) != "") {
            $.ajax({
                url: "../Common/CommonService.asmx/TalukaInsert",
                data: '{Taluka: "' + $("#txtNewTaluka").val() + '",districtID:"' + $("#ddlDistrict").val() + '",cityID:"' + $("#ddlCity").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    Taluka = (result.d);
                    if (Taluka == "0")
                        $('#lblMsg').text('Taluka Already Exist');
                    else if (Taluka > 0) {
                        $('#lblMsg').text('Taluka Saved Successfully');
                        $("#ddlTaluka").append($("<option></option>").val(Taluka).html($("#txtNewTaluka").val()));
                        $("#ddlTaluka").val(Taluka);
                        $("#ddlTaluka option[value='0']").remove();
                    }
                    else
                        $('#lblMsg').text('Taluka Not Saved');

                    $("#txtNewTaluka").val('');
                    $find('mpTaluka').hide();
                },
            });
        }
        else {
            $('#spnErrorTaluka').text('Please Enter Taluka');
            $("#txtNewTaluka").focus();
        }
    }
    function getState() {
        jQuery("#ddlState option").remove();
        jQuery("#ddlDistrict option").remove();
        jQuery("#ddlCity option").remove();
        // jQuery("#ddlTaluka option").remove();
        jQuery.ajax({
            url: "../Common/CommonService.asmx/getState",
            data: '{countryID:"' + jQuery("#ddlNationality").val() + '"}',
            type: "POST",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            async: true,
            dataType: "json",
            success: function (result) {
                StateData = jQuery.parseJSON(result.d);
                if (StateData.length == 0) {
                    jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < StateData.length; i++) {
                        jQuery("#ddlState").append(jQuery("<option></option>").val(StateData[i].StateID).html(StateData[i].StateName));
                    }

                    jQuery("#ddlState").val('<%=GetGlobalResourceObject("Resource", "DefaultStateID") %>');
                    getDistrict();
                }
            },
            error: function (xhr, status) {
                alert("Error ");
                jQuery("#ddlState").attr("disabled", false);
            }
        });
    }
    function getDistrict() {
        $("#ddlDistrict option").remove();
        $("#ddlCity option").remove();
        //  $("#ddlTaluka option").remove();
        $.ajax({
            url: "../Common/CommonService.asmx/getDistrict",
            data: '{countryID:"' + jQuery("#ddlNationality").val() + '",stateID:"' + jQuery("#ddlState").val() + '"}',
            type: "POST",
            contentType: "application/json;charset=utf-8",
            timeout: 1200000,
            async: false,
            dataType: "json",
            success: function (result) {
                DistrictData = jQuery.parseJSON(result.d);
                if (DistrictData.length == 0) {
                    $("#ddlDistrict,#ddlCity,#ddlTaluka").append($("<option></option>").val("0").html("---No Data Found---"));
                    $("#btnNewCity,#btnNewTaluka").attr('disabled', 'disabled');
                }
                else {
                    for (i = 0; i < DistrictData.length; i++) {
                        $("#ddlDistrict").append($("<option></option>").val(DistrictData[i].DistrictID).html(DistrictData[i].District));
                    }
                    $("#ddlDistrict").val('<%=GetGlobalResourceObject("Resource", "DefaultDistrictID") %>');

                    $("#btnNewCity,#btnNewTaluka").removeAttr('disabled');
                    getcity();

                    getTaluka();
                }

            },
            error: function (xhr, status) {
                alert("Error ");
                $("#ddlDistrict").attr("disabled", false);
            }
        });
    }
    function getcity() {
        $("#ddlCity option").remove();

        $.ajax({
            url: "../Common/CommonService.asmx/getCity",
            data: '{ districtID: "' + jQuery("#ddlDistrict").val() + '",StateID:"' + jQuery("#ddlState").val() + '"}',
            type: "POST",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            async: false,
            success: function (result) {
                CityData = jQuery.parseJSON(result.d);
                if (CityData.length == 0) {
                    $("#ddlCity").append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < CityData.length; i++) {
                        $("#ddlCity").append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                    }
                    $("#ddlCity").val('<%=GetGlobalResourceObject("Resource", "DefaultCityID") %>');

                }
                $("#ddlCity").attr("disabled", false);

            },
            error: function (xhr, status) {
                alert("Error ");
                $("#ddlCity").attr("disabled", false);
            }
        });
    }
    function getTaluka() {
        $("#ddlTaluka option").remove();
        $.ajax({
            url: "../Common/CommonService.asmx/getTaluka",
            data: '{ DistrictID: "' + $("#ddlDistrict").val() + '"}',
            type: "POST",
            timeout: 120000,
            async: false,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {

                talukaData = jQuery.parseJSON(result.d);
                if (talukaData.length == 0) {
                    $("#ddlTaluka").append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < talukaData.length; i++) {
                        $("#ddlTaluka").append($("<option></option>").val(talukaData[i].TalukaID).html(talukaData[i].Taluka));
                    }
                    $("#ddlTaluka").val('<%=GetGlobalResourceObject("Resource", "DefaultTaulkaID") %>');

                }
            },
            error: function (xhr, status) {
                alert("Error ");
                $("#ddlTaluka").attr("disabled", false);
            }

        });
    }
    function getCountry() {
        $("#ddlDistrict option").remove();
        $("#ddlCity option").remove();
        $("#ddlTaluka option").remove();
        $.ajax({
            url: "../Common/CommonService.asmx/getCountry",
            data: '{ }',
            type: "POST",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            async: true,
            dataType: "json",
            success: function (result) {
                CountryData = jQuery.parseJSON(result.d);
                if (CountryData.length == 0) {
                    $("#ddlNationality").append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < CountryData.length; i++) {
                        $("#ddlNationality").append($("<option></option>").val(CountryData[i].CountryID).html(CountryData[i].Name));
                    }
                    $("#ddlNationality").val('<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>');
                    getState();
                }
            },
            error: function (xhr, status) {
                alert("Error ");
                $("#ddlNationality").attr("disabled", false);
            }
        });
    }
    function showContactNoLength() {
        if ($('#txtTelephoneNo').val() != "") {
            $('#spnContactNoLength').html($('#txtTelephoneNo').val().length);
        }
        else {
            $('#spnContactNoLength').html('');
        }
    }
    function showRelContactNoLength() {
        if ($('#txtRelationContactNo').val() != "") {
            $('#spnKinContactNoLength').html($('#txtRelationContactNo').val().length);
        }
        else {
            $('#spnKinContactNoLength').html('');
        }
    }
    </script>
</asp:Content>
