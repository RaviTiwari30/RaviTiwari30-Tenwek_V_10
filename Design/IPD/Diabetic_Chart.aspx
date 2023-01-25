<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Diabetic_Chart.aspx.cs" Inherits="Design_IPD_Diabetic_Chart" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <title></title>
    <link rel="Stylesheet" type="text/css" href="../../Styles/chosen.css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../Styles/jquery-ui.css" />
    
    <script type="text/javascript"  src ="../../Scripts/jquery-1.7.1.js"></script>
  
  <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
  <script type="text/javascript" src="../../Scripts/searchableDroplist.js"></script>
   <script type="text/javascript">
       $(function () {
           $('#ddlDoctor').chosen();
       });
       if ($.browser.msie) {
           $(document).on("keydown", function (e) {
               var doPrevent;
               if (e.keyCode == 8) {
                   var d = e.srcElement || e.target;
                   if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                       doPrevent = d.readOnly
                           || d.disabled;
                   }
                   else
                       doPrevent = true;
               }
               else
                   doPrevent = false;
               if (doPrevent) {
                   e.preventDefault();
               }
           });
       }


   </script>
  
     
     <style type="text/css">
         .auto-style1 {
             width: 175px;
         }
         .auto-style2 {
             width: 107px;
         }
         .auto-style3 {
             width: 116px;
         }
     </style>
  
     
</head>
<body>
     <script type="text/javascript">
         function validate(btn,type) {
             if (typeof (Page_Validators) == "undefined") return;
             var TimeON = document.getElementById("<%=maskTime.ClientID%>");

             var LblName = document.getElementById("<%=lblMsg.ClientID%>");
             if ($("#txtDate").val() == "") {
                 $("#txtDate").focus();

                 $("#<%=lblMsg.ClientID%>").text('Please Select Date');
                return false;
            }
            ValidatorValidate(TimeON);
            if (!TimeON.isvalid) {
                LblName.innerText = TimeON.errormessage;
                $("#txtTime").focus();
                return false;
            }
            if ($('#ddlParticular').val() == "0")
            {
                $("#<%=lblMsg.ClientID%>").text('Please Select Particular');
                $('#ddlParticular').focus();
                return false;
            }
             if ($('#txtCBG').val() == "")
             {
                 $("#<%=lblMsg.ClientID%>").text('Please Enter CBG Value');
                 $('#txtCBG').focus();
                 return false;
             }

             if (type == '1') {
                 btn.disabled = true;
                 btn.value = 'Submitting...';
                 __doPostBack('btnSave', '');
             } else {
                 btn.disabled = true;
                 btn.value = 'Submitting...';
                 __doPostBack('btnUpdate', '');
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
     
</script>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <b>Diabetic Chart </b>
                <br />
                  <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
          
        <div class="POuter_Box_Inventory" style="text-align: center;">

            

            <table  style="width:100%;  " >
    
                <tr >
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black" class="auto-style3">Date</td>
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black" class="auto-style2">Time</td>
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black" class="auto-style1">Particulars</td>
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black" class="auto-style1">Value (mmol/L)</td>                 
                    <td style="border: 1px; border-bottom:solid black;border-right:solid black" class="auto-style1">Correction</td>
                    <td style="border: 1px; border-bottom:solid black;border-right:solid black" class="auto-style1">Doctor Name</td>
                </tr>
                <tr >
                    <td style="border: 1px;  border-right:solid black" class="auto-style3">
                        <asp:TextBox ID="txtDate" ClientIDMode="Static" runat="server" Width="91px" Height="16px" CssClass="ItDoseTextinputText"></asp:TextBox>
                         <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></td>
                    <td style="border: 1px;  border-right:solid black" class="auto-style2">
                        <asp:TextBox ID="txtTime" runat="server" Width="80px" ClientIDMode="Static"  CssClass="ItDoseTextinputText"></asp:TextBox>
                     <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label></td>
                    <td style="border: 1px;  border-right:solid black">
                       <asp:DropDownList ID="ddlParticular" runat="server" ClientIDMode="Static">
                           <asp:ListItem Value="0">Select</asp:ListItem>
                           <asp:ListItem Value="FBS">FBS</asp:ListItem>
                           <asp:ListItem Value="PPBS">PPBS</asp:ListItem>
                           <asp:ListItem Value="RBS">RBS</asp:ListItem>
                           <asp:ListItem Value="PRELU">Pre Lunch</asp:ListItem>
                           <asp:ListItem Value="PREDINN">Pre Dinner</asp:ListItem>
                           <asp:ListItem Value="MiddleOFNight">Middle Of Night</asp:ListItem>
                       </asp:DropDownList>
                        </td>
                    <td style="border: 1px;  border-right:solid black">
                    <asp:TextBox ID="txtCBG" MaxLength="7" ClientIDMode="Static"  runat="server" Width="95px" Height="16px" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                    <%-- <cc1:FilteredTextBoxExtender ID="ftbPulse" runat="server"  TargetControlID="txtCBG"   ValidChars="-0123456789"></cc1:FilteredTextBoxExtender>--%>

                        </td>
                    <td style="border: 1px;  border-right:solid black">
                         <asp:TextBox ID="txtCorrection" MaxLength="500" ClientIDMode="Static" runat="server" Width="162px" Height="16px"></asp:TextBox>
                       </td>
                    
                    <td style="border: 1px;  border-right:solid black">
                     <asp:DropDownList ID="ddlDoctor" runat="server" Width="225px" ClientIDMode="Static"></asp:DropDownList></td>
                      </tr>
            </table>
           <em ><span style="color: #0000ff; font-size: 7.5pt">
                       (Type A or P to switch AM/PM)</span></em>
            <asp:Label ID="lblFillTime" runat="server"  Style="display:none" Text="0"></asp:Label>
            <asp:Label ID="lblID" runat="server"  Visible="false" ></asp:Label>
            </div>
               <div class="POuter_Box_Inventory" style="text-align: center;">
            
                   <asp:Button ID="btnSave" OnClientClick="return validate(this,1)" runat="server" Text="Save" OnClick="btnSave_Click"   CssClass="ItDoseButton"/>
              <asp:Button  ID="btnUpdate" runat="server" OnClientClick="return validate(this,2)" Text="Update" OnClick="btnUpdate_Click" CssClass="ItDoseButton" Visible="false"/>
                   <asp:Button ID="bynCancel" runat="server" Text="Cancel" OnClick="bynCancel_Click" CssClass="ItDoseButton"  Visible="false"/>
                   <asp:Button ID="btnPrint" runat="server" Text="Print" OnClick="btnPrint_Click" CssClass="ItDoseButton" />
                  </div>     
                 

          

         <asp:GridView ID="grdDiabiatic" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowCommand="grdDiabiatic_RowCommand" OnRowDataBound="grdDiabiatic_RowDataBound"
                    >
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%# Eval("Date") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%# Eval("Time") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Particulars">
                            <ItemTemplate>
                                <asp:Label ID="lblParticulars" runat="server" Text='<%# Eval("Particulars") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="CBG">
                            <ItemTemplate>
                                <asp:Label ID="lblCBG" runat="server" Text='<%# Eval("CBG") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Correction">
                            <ItemTemplate>
                                <asp:Label ID="lblCorrection" runat="server" Text='<%# Eval("Correction") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField>
                      
                        <asp:TemplateField HeaderText="Doctor Name">
                            <ItemTemplate>
                                  <asp:Label ID="lblDrName" runat="server" Text='<%# Eval("DrName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="User Name">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryBy" runat="server" Text='<%# Eval("EntryBy") %>'></asp:Label>
                                 <asp:Label ID="lblUserID" runat="server" Text='<%#Eval("UserID") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <%# Eval("EntryDate")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                  <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>'  ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                               
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

        </div>
          <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
    TargetControlID="txtTime"  AcceptAMPM="True">
</cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
    ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time"
    InvalidValueMessage="Invalid Time ON"   Display="None"  ></cc1:MaskedEditValidator>
    </form>
    
</body>
    <script type="text/javascript" src='<%= ResolveUrl("../../Scripts/chosen.jquery.js")%>'></script>
</html>
