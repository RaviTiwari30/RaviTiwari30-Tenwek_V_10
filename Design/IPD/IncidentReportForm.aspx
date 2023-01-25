<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IncidentReportForm.aspx.cs" Inherits="Design_IPD_IncidentReportForm"  ClientIDMode="Static"%>
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
        function chkOther() {
            var otherChk=0;
            $("#chkTypeOfIncident input[type=checkbox]:checked").each(function () {
                if($(this).val()=="8")
                    otherChk +=1;
              
            });
            if(otherChk>0)
            {
                $("#trOther").show();
            }

            else
            {
                $("#trOther").hide();
                $("#txtOtherIncident").val('');
            }
        }
        $(document).ready(function () {
            chkOther();
            var MaxLength = 500;
            $("#txtIncidentDetail,#txtFactsBehind,#txtDescribe,#txtCorrective").bind("keyup keydown", function () {
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
        function validate(btn) {
            if ($("#txtIncidentDate").val() == "") {
                $("#lblMsg").text('Please Enter Incident Report Form Date');
                $("#txtIncidentDate").focus();
                return false;
            }
            if ($("#txtDateOfOccurrence").val() == "") {
                $("#lblMsg").text('Please Enter Date of Occurrence');
                $("#txtDateOfOccurrence").focus();
                return false;
            }
            
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
        </script>
    <style type="text/css">
        .auto-style1 {
            width: 204px;
        }
        .auto-style2 {
            width: 261px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
     <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Incident Report Form</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
               <table style="width: 100%">
                   <tr>
                       <td  style="text-align:right;" class="auto-style1">
                           &nbsp;
                           Incident Report Form Date :&nbsp;</td>
                       <td style="text-align:left" class="auto-style2"><asp:TextBox ID="txtIncidentDate" runat="server" Width="90px" AutoPostBack="true" OnTextChanged="txtIncidentDate_TextChanged" ></asp:TextBox>
                             <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtIncidentDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                           <span style="color: red; font-size: 10px;" >*</span>
                             </td>
                       <td  style="text-align:right;">
                           Incident Report Form No. :&nbsp;
                       </td>
                       <td style="text-align:left;">
                           <asp:Label ID="lblIncidentReportID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                          <asp:Label ID="lblIncidentReportNo" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label> 
                       </td>
    </tr>
                  
                    </table>
                    <table style="width: 100%;border-bottom:2px solid black;border-top:2px solid black">
                   <tr ">
                       <td  style="text-align:right;">
                           Name of the Person Involved :&nbsp;
                           </td>
                       <td style="text-align:left;">
                           <asp:TextBox ID="txtName" runat="server" Width="240px" MaxLength="100"></asp:TextBox>
                       </td>
                       <td  style="text-align:right;border-left:2px solid black">
                           Designation :&nbsp;
                       </td>
                       <td style="text-align:left;">
                          <asp:TextBox ID="txtDesignation" runat="server" MaxLength="100"></asp:TextBox>
                       </td>
                       <td  style="text-align:right;border-left:2px solid black">
                           Department :&nbsp;
                       </td>
                       <td style="text-align:left;">
                            <asp:TextBox ID="txtDepartment" runat="server" MaxLength="100"></asp:TextBox>
                       </td>
    </tr>
                   </table>
                
                    <table style="width: 100%;border-bottom:2px solid black;">
                   <tr>
                       <td  style="text-align:right">
                           Date of Occurrence :&nbsp;
                           </td> 
                       <td style="text-align:left">
                           <asp:TextBox ID="txtDateOfOccurrence" runat="server" Width="90px"></asp:TextBox>
                             <cc1:CalendarExtender ID="calcOccurrence" runat="server" TargetControlID="txtDateOfOccurrence" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                       </td>
                        <td  style="text-align:right;border-left:2px solid black">
                           Time :&nbsp;
                           </td> 
                       <td style="text-align:left">
                           <asp:TextBox ID="txtTime" runat="server" MaxLength="8" Width="70px"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                            Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                            <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                       </td>
                        <td  style="text-align:right;border-left:2px solid black">
                           Exact Location :&nbsp;
                           </td> 
                       <td style="text-align:left">
                           <asp:TextBox ID="txtExactLocation" runat="server" MaxLength="100"></asp:TextBox>
                       </td>
                       </tr> 

                        </table>
                    <table style="width: 100%">
                   <tr>

                     <td style="text-align:right">
                           <b>Type of Incident :&nbsp; </b>
                       </td>
                      <td style="text-align:left">
                           <asp:CheckBoxList ID="chkTypeOfIncident" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" onclick="chkOther()">
                               <asp:ListItem Text="Accident" Value="1"></asp:ListItem>
                                 <asp:ListItem Text="Health Related Incident" Value="2"></asp:ListItem>
                                 <asp:ListItem Text="Safety Related Incident" Value="3"></asp:ListItem>
                                 <asp:ListItem Text="Violence" Value="4"></asp:ListItem>
                                 <asp:ListItem Text="Assault" Value="5"></asp:ListItem>
                                 <asp:ListItem Text="Maintance Related Incident" Value="6"></asp:ListItem>
                                 <asp:ListItem Text="Missing/Errors" Value="7"></asp:ListItem>
                               <asp:ListItem Text="Others" Value="8"></asp:ListItem>
                           </asp:CheckBoxList>
                       </td>
                       </tr>
                        <tr id="trOther" style="display:none">
                            <td style="text-align:right">
                                Specify the Incident :&nbsp;
                            </td>
                         <td style="text-align:left">
                                <asp:TextBox ID="txtOtherIncident" MaxLength="100" runat="server" Width="240px"></asp:TextBox>
                            </td>
                        </tr>
                        </table>

               <table style="width: 100%;">
                   <tr>

                       <td style="text-align:left;border-top:2px solid black" colspan="2">
<b>Explain the Incident in details:(Attach Details report that may have contributed to the incident)</b>
                           </td>

                       </tr>
                    <tr>
                        <td  style="border-bottom:2px solid black" colspan="2">
                            <asp:TextBox ID="txtIncidentDetail" runat="server" MaxLength="500" Width="680px" Height="60px" TextMode="MultiLine"></asp:TextBox>
                            <asp:Label ID="Label1" runat="server" Text="Max Char(500)" ForeColor="Red" CssClass="shat"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:left" colspan="2">
                            <b>Facts Behind the Incident :</b>
                        </td>
                    </tr>
                     <tr>
                        <td style="border-bottom:2px solid black" colspan="2">
                            <asp:TextBox ID="txtFactsBehind" runat="server" MaxLength="500" Width="680px" Height="60px" TextMode="MultiLine"></asp:TextBox>
                             <asp:Label ID="Label2" runat="server" Text="Max Char(500)" ForeColor="Red" CssClass="shat"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:left" colspan="2">
                            <b>Describe the Outcome :(Harm/Health Effects/Damage) :</b>
                        </td>
                    </tr>
                     <tr>
                        <td style="border-bottom:2px solid black" colspan="2">
                            <asp:TextBox ID="txtDescribe" runat="server" MaxLength="500" Width="680px" Height="60px" TextMode="MultiLine"></asp:TextBox>
                             <asp:Label ID="Label3" runat="server" Text="Max Char(500)" ForeColor="Red" CssClass="shat"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:left" colspan="2">
                            <b>Corrective/Preventive action to avoid such type of accident/incident in future :</b>
                        </td>
                    </tr>
                     <tr>
                        <td style="border-bottom:2px solid black" colspan="2">
                            <asp:TextBox ID="txtCorrective" runat="server" MaxLength="500" Width="680px" Height="60px" TextMode="MultiLine"></asp:TextBox>
                             <asp:Label ID="Label4" runat="server" Text="Max Char(500)" ForeColor="Red" CssClass="shat"></asp:Label>
                        </td>
                    </tr>
                   
                    </table>
                <table style="width: 100%;border-bottom:2px solid black;display:none" id="tblPrint">
                <tr>
                       <td style="width:20%">
                           Reported by :&nbsp;
                       </td>
                       <td style="width:30%">
                           &nbsp;
                       </td>
                    <td style="width:20%">
                           Date :&nbsp;
                       </td>
                       <td style="width:30%">
                           &nbsp;
                       </td>
                   </tr>
                    <tr>
                       <td style="width:20%">
                           Designation :&nbsp;
                       </td>
                       <td style="width:30%">
                           &nbsp;
                       </td>
                    <td style="width:20%">
                           Time :&nbsp;
                       </td>
                       <td style="width:30%">
                           &nbsp;
                       </td>
                   </tr>
                     </table>
                </div>

          <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server"
                    CssClass="ItDoseButton" Text="Save" OnClientClick="return validate(this)" />
           <asp:Button ID="btnPrint" Text="Print" CssClass="ItDoseButton" runat="server" OnClick="btnPrint_Click"
               Visible="false" />
             </div>
         <script type="text/javascript">
            
    </script>
    </div>
    </form>
</body>
</html>
