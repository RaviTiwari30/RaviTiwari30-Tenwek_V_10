<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OxygenRecord.aspx.cs" Inherits="Design_IPD_OxygenRecord" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../Styles/jquery-ui.css" />
    <script type="text/javascript"  src ="../../Scripts/jquery-1.7.1.js"></script>
  <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
   <script type="text/javascript">
       $(document).ready(function () {
           
           $("#ddlNurseTimeOn").chosen();
           $("#ddlNurseTimeOff").chosen();
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
  
</head>
<body>
    
    <%: System.Web.Optimization.Scripts.Render("~/bundle/js") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/css") %>
    <script type="text/javascript">
        function validate() {
            if (typeof (Page_Validators) == "undefined") return;
            var TimeON = document.getElementById("<%=maskTime.ClientID%>");
            var TimeOFF = document.getElementById("<%=MaskedEditValidator1.ClientID%>"); 
            var LblName = document.getElementById("<%=lblMsg.ClientID%>");
            if ($("#txtDate").val() == "") {
                $("#txtDate").focus();

                $("#<%=lblMsg.ClientID%>").text('Please Select Date');
                return false;
            }
            ValidatorValidate(TimeON);
            if (!TimeON.isvalid) {
                LblName.innerText = TimeON.errormessage;
                $("#txtTimeOn").focus();
                return false;
            }
            if ($("#ddlNurseTimeOn").val() == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Nurse Time On');
                $("#ddlNurseTimeOn").focus(); 
                return false;
            }
            if ($("#ddlDeliveryType").val() == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Delivery Type');
                $("#ddlDeliveryType").focus();
                return false;
            }
            if ($("#txtOxygenDeliveryDetails").val() == "") {
                $("#txtOxygenDeliveryDetails").focus();

                $("#<%=lblMsg.ClientID%>").text('Please Enter Oxygen delivery Details');
                return false;
            }
            if ($.trim($("#txtTimeOff").val()) != "") {
                
                ValidatorValidate(TimeOFF);
                if (!TimeOFF.isvalid) {
                    LblName.innerText = TimeOFF.errormessage;
                    $("#txtTimeOff").focus();
                    return false;
                }
                if ($("#ddlNurseTimeOFF").val() == "0") {
                    $("#<%=lblMsg.ClientID%>").text('Please Select Nurse Time OFF');
                    $("#ddlNurseTimeOFF").focus();
                    return false;
                }
            }

            if ($("#ddlNurseTimeOFF").val() != "0") {
                ValidatorValidate(TimeOFF);
                if (!TimeOFF.isvalid) {
                    LblName.innerText = TimeOFF.errormessage;
                    $("#ddlNurseTimeOFF").focus()
                    return false;
                }
                if ($("#ddlNurseTimeOFF").val() == "0") {
                    $("#<%=lblMsg.ClientID%>").text('Please Select Nurse Time OFF');
                    $("#ddlNurseTimeOFF").focus();
                     return false;
                 }
            }
            if ($("#lblFillTimeON").text() == "1") {
                ValidatorValidate(TimeOFF);
                if (!TimeOFF.isvalid) {
                    LblName.innerText = TimeOFF.errormessage;
                    $("#ddlNurseTimeOFF").focus()
                    return false;
                }
                if ($("#ddlNurseTimeOFF").val() == "0") {
                    $("#<%=lblMsg.ClientID%>").text('Please Select Nurse Time OFF');
                    $("#ddlNurseTimeOFF").focus();
                    return false;
                }
            }
            if ($("#ddlTypeOfTherapy").val() == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Type Of Therapy');
                $("#ddlTypeOfTherapy").focus();
                return false;
            }
        }
    </script>
    <form id="form1" runat="server">
   
     <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <b>Oxygen Record From </b>
                <br />
                  <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
          
        <div class="POuter_Box_Inventory" style="text-align: center;">

            

            <table  style="width:100%;  " >
    
                <tr >
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black">Date ON</td>
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black">Time ON</td>
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black">Nurse(Time ON)</td>
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black">Delivery Type</td>
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black">Oxygen Delivery Details</td>
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black">Date OFF</td>
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black">Time OFF</td>
                    <td style="border: 1px; border-bottom:solid black; border-right:solid black">Nurse(Time OFF)</td>
                  
                    <td style="border: 1px; border-bottom:solid black; display:none">Type Of Therapy</td>
                    
                </tr>
                <tr >
                    <td style="border: 1px;  border-right:solid black">
                        <asp:TextBox ID="txtDate" ClientIDMode="Static" runat="server" Width="80px"></asp:TextBox>
                         <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <cc1:CalendarExtender ID="calOxygenDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></td>
                    <td style="border: 1px;  border-right:solid black">
                        <asp:TextBox ID="txtTimeOn" runat="server" Width="80px" ClientIDMode="Static"  CssClass="ItDoseTextinputText"></asp:TextBox>
                     <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    <td style="border: 1px;  border-right:solid black">
                        <asp:DropDownList ID="ddlNurseTimeOn" ClientIDMode="Static" Width="140px" runat="server"></asp:DropDownList>
                        
                        <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </td>
                        <td style="border: 1px;  border-right:solid black">
                        <asp:DropDownList ID="ddlDeliveryType" ClientIDMode="Static" Width="140px" runat="server">

                             <asp:ListItem Selected="True" Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="Nasal Canula">Nasal Canula</asp:ListItem>
                            <asp:ListItem Value="Facemask">Facemask</asp:ListItem>
                            <asp:ListItem Value="Nonrebreather">Nonrebreather</asp:ListItem>
                              <asp:ListItem Value="Bubble CPAP">Bubble CPAP</asp:ListItem>
                              <asp:ListItem Value="CPAP/BiPap">CPAP/BiPap</asp:ListItem>
                              <asp:ListItem Value="Ventilator">Ventilator</asp:ListItem>
                           
                        </asp:DropDownList>
                        
                        <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </td>
                         <td style="border: 1px;  border-right:solid black">
                             <asp:TextBox ID="txtOxygenDeliveryDetails"  runat="server"  Width="80px" ></asp:TextBox>
                                
                       </td>
                     <td style="border: 1px;  border-right:solid black">
                        <asp:TextBox ID="txtDateOFF" ClientIDMode="Static" runat="server" Width="80px"></asp:TextBox>
                         <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDateOFF" Format="dd-MMM-yyyy"></cc1:CalendarExtender></td>
                    <td style="border: 1px;  border-right:solid black">
                    <asp:TextBox ID="txtTimeOff" runat="server" Width="80px" ClientIDMode="Static"  CssClass="ItDoseTextinputText"></asp:TextBox>
                        <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </td>
                    <td style="border: 1px;  border-right:solid black">
                         <asp:DropDownList ID="ddlNurseTimeOff" ClientIDMode="Static" Width="140px" runat="server"></asp:DropDownList>
                        <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                       </td>
                    
                    <td >
                        <asp:DropDownList ID="ddlTypeOfTherapy" ClientIDMode="Static" Width="150px" runat="server" Visible="false">
                            <asp:ListItem Selected="True" Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="1"></asp:ListItem>
                            <asp:ListItem Value="2"></asp:ListItem>
                            <asp:ListItem Value="3"></asp:ListItem>
                            <asp:ListItem Value="4"></asp:ListItem>
                            <asp:ListItem Value="5"></asp:ListItem>
                            <asp:ListItem Value="6"></asp:ListItem>
                            <asp:ListItem Value="7"></asp:ListItem>
                            <asp:ListItem Value="8"></asp:ListItem>
                            <asp:ListItem Value="9"></asp:ListItem>
                            <asp:ListItem Value="10"></asp:ListItem>
                            <asp:ListItem Value="11"></asp:ListItem>
                            <asp:ListItem Value="12"></asp:ListItem>

                        </asp:DropDownList>
                        <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px; display:none">*</asp:Label>
                    
                </tr>
            </table>
           
                <asp:Label ID="lblPID" runat="server" Visible="false"></asp:Label>
                <asp:Label ID="lblTID" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblFillTimeON" runat="server"  Style="display:none" Text="0"></asp:Label>
            <asp:Label ID="lblOxygenID" runat="server"  Visible="false" ></asp:Label>
            </div>
          <div class="POuter_Box_Inventory" style="text-align: center;">
              <table style="width:100%">
                  <tr>
                      <td style="text-align:left;width:18%">
                           <em ><span style="color: #0000ff; font-size: 7.5pt">
                       (Type A or P to switch AM/PM)</span></em>
                      </td>
                  
             <td style="text-align:center;width:82%">
              <asp:Button ID="btnOxygen" OnClientClick="return validate()" runat="server" Text="Save" OnClick="btnOxygen_Click"   CssClass="ItDoseButton"/>
                         <asp:Button ID="btnUpdate" Visible="false" OnClientClick="return validate()" runat="server" Text="Update" OnClick="btnUpdate_Click"   CssClass="ItDoseButton"/>

                   </td>
                      </tr>
                   </table>
                  </div>

         <asp:GridView ID="grdOxygen" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                 OnRowCommand="grdOxygen_RowCommand"  OnRowDataBound="grdOxygen_RowDataBound" >
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date ON">
                            <ItemTemplate>
                              <asp:Label ID="lblOxygenDateON" runat="server" Text='<%# Eval("OxygenDateON") %>'></asp:Label>  
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Time ON">
                            <ItemTemplate>
                                <asp:Label ID="lblOxygenTimeON" runat="server" Text='<%# Eval("OxygenTimeON") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Time ON(Nurse)">
                            <ItemTemplate>
                                <asp:Label ID="lblNurseTimeONBy" runat="server" Text='<%# Eval("NurseTimeONBy") %>'></asp:Label>
                                <asp:Label ID="lblNurseTimeON" runat="server"  Visible="false" Text='<%# Eval("NurseTimeON") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="DeliveryType">
                            <ItemTemplate>
                                <asp:Label ID="lblDeliveryType" runat="server" Text='<%# Eval("DeliveryType") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="OxygenDeliveryDetails">
                            <ItemTemplate>
                                <asp:Label ID="lblOxygenDeliveryDetails" runat="server" Text='<%# Eval("OxygenDeliveryDetails") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date OFF">
                            <ItemTemplate>
                                <asp:Label ID="lblOxygenDateOFF" runat="server" Text='<%# Eval("OxygenDateOFF") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Time OFF">
                            <ItemTemplate>
                                <asp:Label ID="lblOxygenTimeOFF" runat="server" Text='<%# Eval("OxygenTimeOFF")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Time OFF(Nurse)">
                            <ItemTemplate>
                                <asp:Label ID="lblNurseTimeOffBy" runat="server" Text='<%# Eval("NurseTimeOffBy") %>'></asp:Label>
                                <asp:Label ID="lblNurseTimeOff" runat="server"  Visible="false" Text='<%# Eval("NurseTimeOff") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Hours(H:M:S)">
                            <ItemTemplate>
                                <asp:Label ID="lblHours" runat="server" Text='<%# Eval("Hours")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Therapy" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblTypeOfTherapy" runat="server" Text='<%# Eval("TypeOfTherapy")%>'></asp:Label>
                               <asp:Label ID="lblID" runat="server" Visible="false" Text='<%# Eval("ID")%>'></asp:Label>

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                         
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgResult" runat="server" ImageUrl="../../Images/Edit.png" CommandName="AEdit"
                                    CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
                            </ItemTemplate>
                               
                            
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

         <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
    TargetControlID="txtTimeOn"  AcceptAMPM="True">
</cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTimeOn"
    ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time ON"
    InvalidValueMessage="Invalid Time ON"   Display="None"  ></cc1:MaskedEditValidator>
         <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time"
    TargetControlID="txtTimeOff"  AcceptAMPM="True">
</cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtTimeOff"
    ControlExtender="masTime" IsValidEmpty="true" EmptyValueMessage="Please Enter Time OFF"
    InvalidValueMessage="Invalid Time OFF" Display="None"  ></cc1:MaskedEditValidator>
   </div> 
    </form>
</body>
</html>
