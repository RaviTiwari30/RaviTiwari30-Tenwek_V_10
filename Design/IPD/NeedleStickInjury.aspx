<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NeedleStickInjury.aspx.cs" Inherits="Design_IPD_NeedleStickInjury" ClientIDMode="Static" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            chkKnown();
            var MaxLength = 500;
            $("#txtProcedure").bind("keyup keydown", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > MaxLength) {
                    $(this).val($(this).val().substr(0, MaxLength));
                }
            });
            $("#txtActivities").bind("keyup keydown", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > MaxLength) {
                    $(this).val($(this).val().substr(0, MaxLength));
                }
            });

        });
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
            if (keychar == "~" || keychar == "!" || keychar == "^" || keychar == "*" || keychar == "+" || keychar == "=" || keychar == "{" || keychar == "}" || keychar == "|" || keychar == ";" || keychar == "'" || keychar == "/") {
                return false;
            }
            else {
                return true;
            }
        }

        function chkKnown() {
            if ($("#rblSourceofPatient input[type=radio]:checked").val() == "1") {
                $(".known").show();
            }
            else {
                $(".known").hide();
                $('#rblAntiHCV,#rblHbsAg').find("input[value='2']").attr("checked", "checked");
            }
        }

        function validate(btn) {
            if ($("#txtDate").val() == "") {
                $("#lblMsg").text('Please Enter Date');
                $("#txtDate").focus();
                return false;
            }
            if ($("#txtTime").val() == "") {
                $("#lblMsg").text('Please Enter Time');
                $("#txtTime").focus();
                return false;
            }
            if ($("#ddlName").val() == "0") {
                $("#lblMsg").text('Please Select Name');
                $("#ddlName").focus();
                return false;
            }
            if ($("#txtIncidentDate").val() == "") {
                $("#lblMsg").text('Please Enter Incident Date');
                $("#txtIncidentDate").focus();
                return false;
            }
            if ($("#txtIncidentTime").val() == "") {
                $("#lblMsg").text('Please Enter Incident Time');
                $("#txtIncidentTime").focus();
                return false;
            }
            if ($("#txtReportingDate").val() == "") {
                $("#lblMsg").text('Please Enter Reporting Date');
                $("#txtReportingDate").focus();
                return false;
            }
            if ($("#txtReportingTime").val() == "") {
                $("#lblMsg").text('Please Enter Reporting Time');
                $("#txtReportingTime").focus();
                return false;
            }

            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
    </script>
    <style type="text/css">
        .auto-style1 {
            width: 130px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
     <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Needle Stick Injury Reporting Form</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
               <asp:Label ID="lblInjuryID" Visible="false" runat="server" ></asp:Label>  
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
               <table style="width: 100%">
                   <tr>
                        <td  style="text-align:right">
                            Date :&nbsp;
                            </td>
                       <td style="text-align:left">
                           <asp:TextBox ID="txtDate" runat="server" Width="90px" AutoPostBack="true" OnTextChanged="txtDate_TextChanged" ></asp:TextBox>
                             <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                           <span style="color: red; font-size: 10px;" class="shat">*</span></td>
                        <td colspan="2" style="text-align:right">
                            Time :&nbsp;</td>
                       <td style="text-align:left">
                           &nbsp;<asp:TextBox ID="txtTime" runat="server" Width="70px"></asp:TextBox>
                           <span style="color: red; font-size: 10px;" class="shat">*</span>
                           <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
    TargetControlID="txtTime"  AcceptAMPM="True">
</cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
    ControlExtender="masTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
    InvalidValueMessage="Invalid Time"  ></cc1:MaskedEditValidator>
                       </td>
                       </tr>
                    <tr>
                        <td colspan="2" style="text-align:left">
                   <b> Employee Information </b>
                            </td>
               </tr>
                    <tr>
                        <td style="text-align: right">
                            Name :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlName" runat="server" Width="180px" AutoPostBack="false" OnSelectedIndexChanged="ddlName_SelectedIndexChanged"></asp:DropDownList>
                        <span style="color: red; font-size: 10px;"  class="shat">*</span>
                             </td>
                        <td style="text-align: right">
                           Age :&nbsp;
                        </td>
                        <td style="text-align: left" >
                            <asp:TextBox ID="txtAge" runat="server" Width="60px" MaxLength="3"></asp:TextBox>
                           <asp:DropDownList ID="ddlAge" runat="server" Width="80px">
                                <asp:ListItem Text="YRS" Value="YRS"></asp:ListItem>
                                <asp:ListItem Text="Month" Value="Month"></asp:ListItem>
                                <asp:ListItem Text="Days" Value="Days"></asp:ListItem>
                            </asp:DropDownList>
                            <cc1:FilteredTextBoxExtender ID="ftbAge" runat="server" TargetControlID="txtAge" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </td>
                       <td></td>
                        </tr>
                     <tr>
                        <td style="text-align: right">
                            Department/Ward :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:Label ID="lblWard" runat="server" ></asp:Label>
                            <asp:Label ID="lblWardID" runat="server" ></asp:Label>
                        </td>
                        <td style="text-align: right">
                           Sex :&nbsp;
                        </td>
                        <td style="text-align: left" class="auto-style1">
                            <asp:RadioButtonList ID="rblSex" runat="server" RepeatColumns="2" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Male" Value="M"></asp:ListItem>
                                 <asp:ListItem Text="Female" Value="F"></asp:ListItem>
                            </asp:RadioButtonList>
                            
                        </td>
                        </tr>
                     <tr>
                        <td style="text-align: right">
                            Address :&nbsp;
                        </td>
                        <td style="text-align: left">
                           <asp:TextBox ID="txtAddress" runat="server" Width="240px" MaxLength="100"></asp:TextBox>
                        </td>
                        <td style="text-align: right">
                           Designation :&nbsp;
                        </td>
                        <td style="text-align: left" class="auto-style1">
                            <asp:TextBox ID="txtDesignation" runat="server" Width="180px" MaxLength="100"></asp:TextBox>
                            
                        </td>
                        </tr>
                    </table>
                </div>
      <div class="POuter_Box_Inventory" style="text-align: center;">
           <table style="width: 100%">
                    <tr>
                        <td style="text-align: right">
                            Date&nbsp;and&nbsp;Time&nbsp;of&nbsp;Incident&nbsp;:&nbsp;
                            </td>
                        <td style="text-align: left">
                             <asp:TextBox ID="txtIncidentDate" runat="server" Width="90px"></asp:TextBox>
                            <span style="color: red; font-size: 10px;" class="shat">*</span>
                               <cc1:CalendarExtender ID="calIncidentDate" runat="server" TargetControlID="txtIncidentDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                             <asp:TextBox ID="txtIncidentTime" runat="server" Width="70px"></asp:TextBox>
                            <span style="color: red; font-size: 10px;" class="shat">*</span>
                            <cc1:MaskedEditExtender ID="maskIncidentTime" Mask="99:99" runat="server" MaskType="Time"
    TargetControlID="txtIncidentTime"  AcceptAMPM="True">
</cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="maskEIncidentTime" runat="server" ControlToValidate="txtIncidentTime"
    ControlExtender="maskIncidentTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
    InvalidValueMessage="Invalid Time"  ></cc1:MaskedEditValidator>
                        </td>
                         <td style="text-align: right">
                            Date&nbsp;and&nbsp;Time&nbsp;of&nbsp;Reporting&nbsp;:&nbsp;
                            </td>
                         <td style="text-align: left">
                              <asp:TextBox ID="txtReportingDate" runat="server" Width="90px"></asp:TextBox>
                             <span style="color: red; font-size: 10px;" class="shat">*</span>
                              <cc1:CalendarExtender ID="calReportingDate" runat="server" TargetControlID="txtReportingDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                             <asp:TextBox ID="txtReportingTime" runat="server" Width="70px"></asp:TextBox>
                             <span style="color: red; font-size: 10px;" class="shat">*</span>
                             <cc1:MaskedEditExtender ID="maskReportingTime" Mask="99:99" runat="server" MaskType="Time"
    TargetControlID="txtReportingTime"  AcceptAMPM="True">
</cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="maskdReportingTime" runat="server" ControlToValidate="txtIncidentTime"
    ControlExtender="maskReportingTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
    InvalidValueMessage="Invalid Time"  ></cc1:MaskedEditValidator>
                        </td>
                        </tr>

               </table>
           <table style="width: 100%">
                <tr>
                        <td style="text-align: center;width:50%">
                            Procedure at the time of Incident
                            </td>
                    <td style="text-align: center;width:50%">
                        Activities after Incident
                    </td>
                    </tr>
               <tr>
                   <td style="text-align: center;width:50%">
                       <asp:TextBox ID="txtProcedure" runat="server" Width="320px" TextMode="MultiLine" Height="80px" onkeypress="return check(this,event)"></asp:TextBox>
                   <asp:Label ID="Label3" runat="server" Text="Max Char(500)" ForeColor="Red" CssClass="shat"></asp:Label>
                   </td>
                   <td style="text-align: center;width:50%">
                       <asp:TextBox ID="txtActivities" runat="server" Width="320px" TextMode="MultiLine" Height="80px" onkeypress="return check(this,event)"></asp:TextBox>
                <asp:Label ID="Label1" runat="server" Text="Max Char(500)" ForeColor="Red" CssClass="shat"></asp:Label>
                          </td>
               </tr>
               </table>
           </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
           <table style="width: 100%">
                    <tr>
                        <td style="text-align: right">
                            Nature of Injury :&nbsp;
                            </td>
                        <td>
                            <asp:CheckBoxList ID="chkInjury" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" RepeatLayout="Table">
                                <asp:ListItem Text="Superficial" Value="1"></asp:ListItem>
                                 <asp:ListItem Text="Moderate" Value="2"></asp:ListItem>
                                 <asp:ListItem Text="Deep" Value="3"></asp:ListItem>
                                 <asp:ListItem Text="Bleeding" Value="4"></asp:ListItem>
                            </asp:CheckBoxList>
                        </td>
                        </tr>
               <tr>
                        <td style="text-align: right">
                            Type of Contamination :&nbsp;
                            </td>
                        <td style="text-align: left">
                            <asp:RadioButtonList ID="rblContamination" runat="server" RepeatColumns="4" RepeatLayout="Table" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Blood" Value="1" />
                                <asp:ListItem Text="Non Blood Stained Fluid" Value="2"/>
                                  <asp:ListItem Text="Blood Stained Fluid" Value="3" />
                                <asp:ListItem Text="Unknown" Value="4" Selected="True"/>
                            </asp:RadioButtonList> 
                        </td>
                        </tr>
                <tr>
                        <td  colspan="2" style="text-align: left">
                            <b>Risk Assessment/Treatment</b> 
                            </td>

                    </tr>
               <tr>
                   <td style="text-align: right">
                       First Aid :&nbsp;
                   </td>
                   <td style="text-align: left">
                        <asp:RadioButtonList ID="rblFirstAid" runat="server" RepeatColumns="4" RepeatLayout="Table" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True"/>
                            </asp:RadioButtonList>
                   </td>
               </tr>
               <tr>
                   <td style="text-align: right">
                       Gloves Worn :&nbsp;
                   </td>
                   <td style="text-align: left">
                        <asp:RadioButtonList ID="rblGlovesWorn" runat="server" RepeatColumns="4" RepeatLayout="Table" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True"/>
                            </asp:RadioButtonList>
                   </td>
               </tr>
               <tr>
                   <td style="text-align: right">
                   Date of Last HEP B Course/Booster/Anti HBS :&nbsp;
                       </td>
                   <td style="text-align: left">
                       <asp:TextBox ID="txtHEPDate" runat="server" Width="90px"></asp:TextBox>
                         <cc1:CalendarExtender ID="calHEPDate" runat="server" TargetControlID="txtHEPDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                   </td>
               </tr>
                <tr>
                   <td style="text-align: right">
                   Date of Last Last Tetanus :&nbsp;
                       </td>
                   <td style="text-align: left">
                       <asp:TextBox ID="txtTetanusDate" runat="server" Width="90px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calTetanusDate" runat="server" TargetControlID="txtTetanusDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                   </td>
               </tr>
               <tr>
                   <td  style="text-align:right">
                     Information Regarding Source of Patient :&nbsp;
                   </td>
                   <td>
                        <asp:RadioButtonList ID="rblSourceofPatient" onclick="chkKnown()" runat="server" RepeatColumns="4" RepeatLayout="Table" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Known" Value="1" />
                                <asp:ListItem Text="UnKnown" Value="0" Selected="True"/>
                            </asp:RadioButtonList>
                   </td>
               </tr>
               <tr class="known" style="display:none">
                   <td colspan="2" style="text-align:left">
                  <b> If Known Patient :&nbsp;</b>
                       </td>
                  
               </tr>
              <tr class="known" style="display:none">
                   <td  style="text-align:right">
                     Anti HCV+ :&nbsp;
                   </td>
                   <td>
                        <asp:RadioButtonList ID="rblAntiHCV" runat="server" RepeatColumns="4" RepeatLayout="Table" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" />
                             <asp:ListItem Text="Not Known" Value="2" Selected="True"/>
                            </asp:RadioButtonList>
                   </td>
               </tr>
               <tr class="known" style="display:none">
                   <td  style="text-align:right">
                     HbsAg :&nbsp;
                   </td>
                   <td>
                        <asp:RadioButtonList ID="rblHbsAg" runat="server" RepeatColumns="4" RepeatLayout="Table" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" />
                             <asp:ListItem Text="Not Known" Value="2" Selected="True"/>
                            </asp:RadioButtonList>
                   </td>
               </tr>
               
               </table>
              </div>
              <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server"
                    CssClass="ItDoseButton" Text="Save" OnClientClick="return validate(this)" />
             <asp:Button ID="btnPrint" Text="Print" CssClass="ItDoseButton" runat="server" OnClick="btnPrint_Click"
                 Visible="true" />
             </div>
    </div>
    </form>
</body>
</html>
