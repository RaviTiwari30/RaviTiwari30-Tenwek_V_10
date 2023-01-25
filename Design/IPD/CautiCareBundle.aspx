<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CautiCareBundle.aspx.cs" Inherits="Design_IPD_CautiCareBundle" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%-- <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>--%>
    <style type="text/css">
        .col-md-16 {
              display: flex;
            }
        .col-md-16 > div {
                  border: 1px solid black;
                }
            
    </style>
</head>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
   <%-- <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#spnPatientID").text('<%=Request.QueryString["PID"].ToString() %>');
            $("#spnTransactionID").text('<%=Request.QueryString["TID"].ToString() %>');
            //bindData();
        });
        function validate() {
            //if ($('#ddlThePatient').val() == "0" || $('#ddlTheUrinary').val() == "0" || $('#ddlDailyMeatalHygiene').val() == "0" && $('#ddlUrinaryCatheterBag').val() == "0" || $('#ddlHandHygiene').val() == "0" || $('#ddlPatientAnd').val() == "0" ) {
            //    modelAlert("Please Fill Details.", function () { });
            //    return false;
            //}
        }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>Cauti Care Bundle </b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   Cauti Care Bundle
                </div>
 
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <div class="col-md-2" >Date
                        </div>
                     <div class="col-md-5">
                          <span  style="display:none;"  id="spnTransactionID"></span>
                   
                        <span style="display:none;" id="spnPatientID"></span>
                        
                        <span  style="display:none;"  id="spnEditPatientNote"></span>
                                   <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                        </div>
                     <div class="col-md-2" >Time
                        </div>
                     <div class="col-md-8">
                          <asp:TextBox ID="txtTime" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            
                        </div>
                    </div>
                </div>
                 
 
            <div class="POuter_Box_Inventory" style="text-align: left;">
                <div class="row">
                    <div class="col-md-24">
                        <table style="width:100%;" class="FixedTables" >
                            <tr>
                            <th class="GridViewHeaderStyle"  style="width:20px;" >1</th>
                            <th class="GridViewHeaderStyle"  >Bundle Criteria</th>
                            <th class="GridViewHeaderStyle" >Response</th>
                            </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >1</td>
                              <td class="GridViewLabItemStyle" >The Patient has been accessed of continual need of Urinary Catheter</td>
                              <td class="GridViewLabItemStyle" >
                                   <asp:DropDownList id="ddlThePatient" runat="server" Width="400px"  >
                                       <asp:ListItem value="0"  Text="--Select--" />
                                       <asp:ListItem value="1"  Text="Yes" />
                                         <asp:ListItem value="2"  Text="No" />
                                   </asp:DropDownList> 
                                 </td>
                        </tr>
                         <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >2</td>
                              <td class="GridViewLabItemStyle" >The Urinary Catheter has been continuously connected</td>
                              <td class="GridViewLabItemStyle" >
                                    <asp:DropDownList id="ddlTheUrinary" runat="server" Width="400px"  >
                                       <asp:ListItem value="0"  Text="--Select--" />
                                       <asp:ListItem value="1"  Text="Yes" />
                                         <asp:ListItem value="2"  Text="No" />
                                   </asp:DropDownList> 
                              </td>
                        </tr> 
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >3</td>
                              <td class="GridViewLabItemStyle" >Daily Meatal Hygiene has been performed on the patient </td>
                              <td class="GridViewLabItemStyle" >
                                    <asp:DropDownList id="ddlDailyMeatalHygiene" runat="server" Width="400px"  >
                                       <asp:ListItem value="0"  Text="--Select--" />
                                       <asp:ListItem value="1"  Text="Yes" />
                                         <asp:ListItem value="2"  Text="No" />
                                   </asp:DropDownList> 
                                 
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >4</td>
                              <td class="GridViewLabItemStyle" >Urinary Catheter bag has been emptied routinely, into clean container
</td>
                              <td class="GridViewLabItemStyle" >
                                   <asp:DropDownList id="ddlUrinaryCatheterBag" runat="server" Width="400px"  >
                                       <asp:ListItem value="0"  Text="--Select--" />
                                       <asp:ListItem value="1"  Text="Yes" />
                                         <asp:ListItem value="2"  Text="No" />
                                   </asp:DropDownList> 
                                 
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >5</td>
                              <td class="GridViewLabItemStyle" >Hand Hygiene performed and gloves worn before and after procedure</td>
                              <td class="GridViewLabItemStyle" >
                                   <asp:DropDownList id="ddlHandHygiene" runat="server" Width="400px"  >
                                       <asp:ListItem value="0"  Text="--Select--" />
                                       <asp:ListItem value="1"  Text="Yes" />
                                         <asp:ListItem value="2"  Text="No" />
                                   </asp:DropDownList> 
                                 
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >6</td>
                              <td class="GridViewLabItemStyle" >Patient and/or care taker sensitized on catheter care </td>
                              <td class="GridViewLabItemStyle" > 
                                   <asp:DropDownList id="ddlPatientAnd" runat="server" Width="400px"  >
                                       <asp:ListItem value="0"  Text="--Select--" />
                                       <asp:ListItem value="1"  Text="Yes" />
                                         <asp:ListItem value="2"  Text="No" />
                                   </asp:DropDownList> 
                                 
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >7</td>
                              <td class="GridViewLabItemStyle" >Checked By (initials)
</td>
                              <td class="GridViewLabItemStyle" >
                                  <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                                  <asp:TextBox ID="txtCheckedBy" CssClass="" runat="server" Width="400px"  ClientIDMode="Static" MaxLength="50"  disabled ></asp:TextBox>
                           </td>
                        </tr>
                        </table>
                    </div>
                </div>
               
               
               
               
                
                </div>
                
            
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" ClientIDMode="Static" runat="server" OnClick="btnSave_Click" Text="save" CssClass="ItDoseButton"  OnClientClick="return validate();"   />
                <asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return validate();" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" Visible="false" OnClick="btnCancel_Click" />
               <%--  <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" TabIndex="69" OnClick="btnPrint_Click" />
            
              <input type="button" value="Save" id="btnSave" title="Save All Details" onclick="SaveData();" />--%>
            </div>
                 
             <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ThePatient">
                            <ItemTemplate>
                                <asp:Label ID="lblThePatient" runat="server" Text='<%#Eval("ThePatient1") %>'></asp:Label>
                                <asp:Label ID="lblThePatient1" runat="server" Text='<%#Eval("ThePatient") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="TheUrinary ">
                            <ItemTemplate>
                                <asp:Label ID="lblTheUrinary" runat="server" Text='<%#Eval("TheUrinary1") %>'></asp:Label>
                                <asp:Label ID="lblTheUrinary1" runat="server" Text='<%#Eval("TheUrinary") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="DailyMeatal ">
                            <ItemTemplate>
                                <asp:Label ID="lblDailyMeatal" runat="server" Text='<%#Eval("DailyMeatal1") %>'></asp:Label>
                                <asp:Label ID="lblDailyMeatal1" runat="server" Text='<%#Eval("DailyMeatal") %>'  Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UrinaryCatheter">
                            <ItemTemplate>
                                <asp:Label ID="lblUrinaryCatheter" runat="server" Text='<%#Eval("UrinaryCatheter1") %>'></asp:Label>
                                <asp:Label ID="lblUrinaryCatheter1" runat="server" Text='<%#Eval("UrinaryCatheter") %>'  Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="HandHygiene ">
                            <ItemTemplate>
                                <asp:Label ID="lblHandHygiene" runat="server" Text='<%#Eval("HandHygiene1") %>'></asp:Label>
                                <asp:Label ID="lblHandHygiene1" runat="server" Text='<%#Eval("HandHygiene") %>'  Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientAnd">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientAnd" runat="server" Text='<%#Eval("PatientAnd1") %>'></asp:Label>
                                <asp:Label ID="lblPatientAnd1" runat="server" Text='<%#Eval("PatientAnd") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Checked By">
                            <ItemTemplate>
                                <asp:Label ID="lblCheckedBy" runat="server" Text='<%#Eval("CheckedBy1")  %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID1" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Entry By" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                                <asp:Label ID="lblCreatedID" runat="server" Text='<%#Eval("CreatedBy") %>' Visible="false"></asp:Label>
                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit" >
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                <asp:Label ID="lblUserID" Text='<%#Eval("CreatedBy") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>  
                                            
                                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60" />
                        </asp:TemplateField>
                    <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgbtnEdit1" AlternateText="Edit" CommandName="Print" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/print.gif" runat="server" />
                                                <asp:Label ID="lblID1" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                
                                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="60" />
                        </asp:TemplateField>
                    
                    </Columns>
                </asp:GridView>
            </div>
             
         
        </div>
    </form>

</body>
</html>

