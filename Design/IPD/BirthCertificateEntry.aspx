<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BirthCertificateEntry.aspx.cs" Inherits="Design_IPD_BirthCertificateEntry" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/framestyle.css" />
      <link rel="stylesheet" type="text/css" href="../../Styles/CustomStyle.css" />
    <script type="text/javascript">
        $(document).on("change", "#ddlHeight", function () {
            validateMaximumHeight();
        });
        $(document).on("change", "#ddlWeight", function () {
            validateMaximumWeight();
        });
       
        $(document).on("keyup", "#txtWeight", function () {       
            validateMaximumWeight();
        });      
        
        $(document).on("keyup", "#txtHeight", function () {       
            validateMaximumHeight();
        });
        function validateMaximumHeight() {
            if ((parseFloat($("#txtHeight").val()) > parseFloat('60.96')) && ($('#ddlHeight').val() == 'CM')) {
                $("#txtHeight").val('')
                $("#txtHeight").focus();
                $("#lblMsg").text("Height should not be greater than 60.96 CM");
                return false
            }
            if ((parseFloat($("#txtHeight").val()) > parseFloat('609.6')) && ($('#ddlHeight').val() == 'MM')) {
                $("#txtHeight").val('')
                $("#txtHeight").focus();
                $("#lblMsg").text("Height should not be greater than 609.6 MM");
                return false
            }
            if ((parseFloat($("#txtHeight").val()) > parseFloat('2')) && ($('#ddlHeight').val() == 'FT')) {
                $("#txtHeight").val('')
                $("#txtHeight").focus();
                $("#lblMsg").text("Height should not be greater than 2 FT");
                return false
            }
            if ((parseFloat($("#txtHeight").val()) > parseFloat('24')) && ($('#ddlHeight').val() == 'INCH')) {
                $("#txtHeight").val('')
                $("#txtHeight").focus();
                $("#lblMsg").text("Height should not be greater than 24 INCH");
                return false
            }
        }
            function validateMaximumWeight(){
                if ((parseFloat($("#txtWeight").val()) > parseFloat('5000')) && ($('#ddlWeight').val() == 'gm')) {
                    $("#txtWeight").val('')               
                    $("#txtWeight").focus();
                    $("#lblMsg").text("Height should not be greater than 5000 gm");
                    return false
                }
                if ((parseFloat($("#txtWeight").val()) > parseFloat('5')) && ($('#ddlWeight').val() == 'kg')) {
                    $("#txtWeight").val('')
                    $("#txtWeight").focus();
                    $("#lblMsg").text("Weight should not be greater than 5 Kg");
                    return false
                }
                if ((parseFloat($("#txtWeight").val()) > parseFloat('11.023')) && ($('#ddlWeight').val() == 'lb')) {
                    $("#txtWeight").val('')
                    $("#txtWeight").focus();
                    $("#lblMsg").text("Height should not be greater than 11.023 lb");
                    return false
                }               
            }
        function validate() {
            var flag = true;

            if ($.trim($("#txtIssueDate").val()) == "") {
                flag = false;
                $("#lblMsg").text("Please Select Issue Date");
                $("#txtIssueDate").focus();
            }
            else if ($.trim($("#txtDeliveryDate").val()) == "") {
                flag = false;
                $("#lblMsg").text("Please Select Delivery Date");
                $("#txtDeliveryDate").focus();
            }
            else if ($.trim($("#txtDeliveryTime").val()) == "") {
                flag = false;
                $("#lblMsg").text("Please Enter Delivery Time");
                $("#txtDeliveryDate").focus();
            }
            else if ($.trim($("#ddlDeliveryType option:selected").text()) == "SELECT") {
                flag = false;
                $("#lblMsg").text("Please Select Delivery Type");
                $("#ddlDeliveryType").focus();
            }
            else if ($.trim($("#txtBabyName").val()) == "") {
                flag = false;
                $("#lblMsg").text("Please Enter Baby Name");
                $("#txtBabyName").focus();
            }
            //else if ($.trim($("#txtHeight").val()) == "") {
            //    flag = false;
            //    $("#lblMsg").text("Please Enter Height");
            //    $("#txtHeight").focus();
            //}
            else if (parseFloat($.trim($("#txtHeight").val())) > 0 && $.trim($("#ddlHeight option:selected").text()) == "SELECT") {
                flag = false;
                $("#lblMsg").text("Please Select Height Unit");
                $("#ddlHeight").focus();
            }
            else if ($.trim($("#txtWeight").val()) == "") {
                flag = false;
                $("#lblMsg").text("Please Enter Weight");
                $("#txtWeight").focus();
            }
            else if (parseFloat($.trim($("#txtWeight").val())) > 0 && $.trim($("#ddlWeight option:selected").text()) == "SELECT") {
                flag = false;
                $("#lblMsg").text("Please Select Weight Unit");
                $("#ddlWeight").focus();
            }
            else if ($.trim($("#txtWeight").val()) == "") {
                flag = false;
                $("#lblMsg").text("Please Enter Weight");
                $("#txtWeight").focus();
            }
            else if ($.trim($("#txtGuardian").val()) == "") {
                flag = false;
                $("#lblMsg").text("Please Enter Guardian Name");
                $("#txtGuardian").focus();
            }
            else if ($.trim($("#txtAddress").val()) == "") {
                flag = false;
                $("#lblMsg").text("Please Enter Guardian Address");
                $("#txtAddress").focus();
            }

            return flag;
        }

        function validateSave() {
            $("#lblMsg").text("");
            $("#btnSave").val("Submitting...").attr("disabled", "disabled");

            if (validate()) {
                __doPostBack("btnSave", "");
                return true;
            }
            else {
                $("#btnSave").val("Save").removeAttr("disabled");
                return false;
            }
        }

        function validateUpdate() {
            $("#lblMsg").text("");
            $("#btnUpdate").val("Submitting...").attr("disabled", "disabled");

            if (validate()) {
                __doPostBack("btnUpdate", "");                
                return true;
            }
            else {
                $("#btnUpdate").val("Update").removeAttr("disabled");
                return false;
            }
        }

        function check(sender, e) {
            var keynum
            var keychar
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

            if (keychar == "~" || keychar == "!" || keychar == "^" || keychar == "*" || keychar == "+" || keychar == "=" || keychar == "{" || keychar == "}" || keychar == "|" || keychar == ";" || keychar == "'" || keychar == "`") {
                return false;
            }
            else {
                return true;
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

        function validateDecimal(txtBox) {
            var DigitsAfterDecimal = 2;
            var val = $(txtBox).val();
            var valIndex = val.indexOf(".");
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    $(txtBox).val($(txtBox).val().substring(0, ($(txtBox).val().length - 1)));
                    return false;
                }
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Birth Certificate Entry</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Birth Certificate Entry
                </div>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 20%; text-align: right;">
                            <asp:Label ID="lblNumberHeader" runat="server" Font-Bold="true" Text="Number :" Visible="false" />&nbsp;
                        </td>
                        <td style="width: 20%; text-align: left;">
                            <asp:Label ID="lblNumberValue" runat="server" Font-Bold="true" Visible="false" />
                        </td>
                        <td style="width: 20%; text-align: right;"></td>
                        <td style="width: 30%; text-align: left;"></td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Date Of Issue :&nbsp;</td>
                        <td style="width: 20%; text-align: left;">
                            <asp:TextBox ID="txtIssueDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Date" Width="150px" />
                            <cc1:CalendarExtender ID="calIssueDate" runat="server" TargetControlID="txtIssueDate" Format="dd-MMM-yyyy" Animated="true" />
                        </td>
                        <td style="width: 20%; text-align: right;">Delivery Type :&nbsp;</td>
                        <td style="width: 30%; text-align: left;">
                            <asp:DropDownList ID="ddlDeliveryType"  CssClass="requiredField" runat="server" ClientIDMode="Static" ToolTip="Select Nature of Delivery" Width="155px" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Date Of Delivery :&nbsp;</td>
                        <td style="width: 20%; text-align: left;">
                            <asp:TextBox ID="txtDeliveryDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Date" Width="150px" />
                            <cc1:CalendarExtender ID="calDeliveryDate" runat="server" TargetControlID="txtDeliveryDate" Format="dd-MMM-yyyy" Animated="true" />
                        </td>
                        <td style="width: 20%; text-align: right;">Time Of Delivery :&nbsp;</td>
                        <td style="width: 30%; text-align: left;">
                            <asp:TextBox ID="txtDeliveryTime" runat="server" ToolTip="Enter Time" CssClass="ItDoseTextinputText" Width="68px" MaxLength="5" />
                            <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtDeliveryTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtDeliveryTime" ControlExtender="masTime" IsValidEmpty="true" EmptyValueMessage="Time Required" InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Baby Name :&nbsp;</td>
                        <td style="width: 20%; text-align: left;">
                            <asp:TextBox ID="txtBabyName" runat="server" CssClass="requiredField" ClientIDMode="Static" ToolTip="Enter Baby Name" MaxLength="25" Width="150px" onkeypress="return check(this, event);" />
                            
                        </td>
                        <td style="width: 20%; text-align: right;">Gender :&nbsp;</td>
                        <td style="width: 30%; text-align: left;">
                            <asp:RadioButtonList ID="rblGender" runat="server" ClientIDMode="Static" ToolTip="Select Gender" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Male" Selected="True" />
                                <asp:ListItem Text="Female" />
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Height :&nbsp;</td>
                        <td style="width: 20%; text-align: left;">
                            <asp:TextBox ID="txtHeight" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" ToolTip="Enter Baby Weight" MaxLength="8" Width="72px" onkeypress="return checkForSecondDecimal(this,event);" onkeyup="validateDecimal(this);" />
                            <cc1:FilteredTextBoxExtender ID="ftbeHeight" runat="server" TargetControlID="txtHeight" FilterType="Custom,Numbers" ValidChars="." />
                            <asp:DropDownList ID="ddlHeight" runat="server" ClientIDMode="Static" ToolTip="Select Height Unit" Width="72px">
                                <asp:ListItem Text="SELECT" Selected="True" />
                                <asp:ListItem Text="CM" Value="CM" />
                                <asp:ListItem Text="MM" Value="MM"  />
                                <asp:ListItem Text="FT" Value="FT"  />
                                <asp:ListItem Text="INCH" Value="INCH"  />
                            </asp:DropDownList>
                            <%--<span class="ItDoseLblError">*</span>--%>
                        </td>
                        <td style="width: 20%; text-align: right;">Weight :&nbsp;</td>
                        <td style="width: 30%; text-align: left;">
                            <asp:TextBox ID="txtWeight" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" ToolTip="Enter Baby Weight" MaxLength="8" Width="72px" onkeypress="return checkForSecondDecimal(this,event);" onkeyup="validateDecimal(this);" />
                            <cc1:FilteredTextBoxExtender ID="ftbeWeight" runat="server" TargetControlID="txtWeight" FilterType="Custom,Numbers" ValidChars="." />
                            <asp:DropDownList ID="ddlWeight" runat="server" CssClass="requiredField"  ClientIDMode="Static" ToolTip="Select Weight Unit" Width="72px">
                                <asp:ListItem Text="SELECT" Selected="True" />
                                <asp:ListItem Text="gm" Value="gm" />
                                <asp:ListItem Text="kg" Value="kg" />
                                <asp:ListItem Text="lb" Value="lb" />
                            </asp:DropDownList>
                            
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right; vertical-align: top;">Father Name :&nbsp;</td>
                        <td style="width: 20%; text-align: left; vertical-align: top;">
                            <asp:TextBox ID="txtGuardian" CssClass="requiredField" runat="server" ClientIDMode="Static" ToolTip="Enter Father Name" MaxLength="25" Width="150px" onkeypress="return check(this, event);" />
                            
                        </td>
                        <td style="width: 20%; text-align: right; vertical-align: top;">Consultant Doctor :&nbsp;</td>
                        <td style="width: 20%; text-align: left; vertical-align: top;">
                             <asp:DropDownList runat="server" ID="ddlConsultantDoctor" Width="155px">

                            </asp:DropDownList>
                        </td>
                        

                    </tr>

                    <tr>
                         <td style="width: 20%; text-align: right; vertical-align: top;"></td>
                        <td style="width: 20%; text-align: left; vertical-align: top;">
                           

                        </td>
                         <td style="width: 20%; text-align: right; vertical-align: top;">Address :&nbsp;</td>
                        <td style="width: 30%; text-align: left; vertical-align: top;">
                            <asp:TextBox ID="txtAddress" CssClass="requiredField" runat="server" ClientIDMode="Static" ToolTip="Enter Address" MaxLength="100" Width="300px" Height="50px" onkeypress="return check(this, event);" TextMode="MultiLine" />
                            
                        </td>
                        

                        <td>
                            
                        </td>
                    </tr>

                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Save" ToolTip="Click To Save" OnClick="btnSave_Click" OnClientClick="return validateSave();" />
                <asp:Button ID="btnUpdate" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Update" ToolTip="Click To Update" OnClick="btnUpdate_Click" OnClientClick="return validateUpdate();" Visible="false" />
                  <asp:Button ID="btnPrint" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Print" ToolTip="Click To Print" OnClick="btnPrint_Click" />
                <asp:Button ID="btnCancel" runat="server" ClientIDMode="Static"  CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Print" OnClick="btnCancel_Click" />
            </div>

            <div class="POuter_Box_Inventory" >

               
                 <asp:GridView ID="GridView1" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            OnRowCommand="GridView1_RowCommand"   >
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                             
                                <asp:BoundField DataField="Number" HeaderText="Birth Number">
                                    <ItemStyle Width="240px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="BabyName" HeaderText="Baby Name">
                                    <ItemStyle Width="340px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Gender" HeaderText="Gender">
                                    <ItemStyle Width="80px" HorizontalAlign="Center" CssClass="GridViewItemStyle"></ItemStyle>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Print" ItemStyle-HorizontalAlign="Center" >
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandName="imbPrint"
                                            CommandArgument='<%# Eval("Number") %>' ImageUrl="~/Images/print.gif" />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle"  Width="140px"/>
                                </asp:TemplateField>
                                

                                 <asp:TemplateField HeaderText="Edit" ItemStyle-HorizontalAlign="Center" >
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="imbEdit"
                                            CommandArgument='<%# Eval("Number") %>' ImageUrl="~/Images/edit.png" />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle"  Width="140px"/>
                                </asp:TemplateField>

                                 
                            </Columns>
                        </asp:GridView>



            </div>



        </div>
    </form>
</body>
</html>
