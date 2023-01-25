<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HistologyForm.aspx.cs" Inherits="Design_IPD_HistologyForm" %>
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
            if ($('#txtFacial').val() == "" && $('#txtCry').val() == "" && $('#txtBreathing').val() == "" && $('#txtArms').val() == "" && $('#txtLegs').val() == "" && $('#txtState').val() == "" && $('#txtTotal').val() == "" && $('#txtAction').val() == "") {
                modelAlert("Please Fill Details.", function () { });
                return false;
            }
        }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>Histology/Cytology Examination Request Form </b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   Upper Endoscopy
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
                                   <td class="GridViewLabItemStyle"    style="width:16.66%;"  colspan="1"  >Patient Name</td>
                                   <td class="GridViewLabItemStyle"    style="width:33.33%;"  colspan="2"    >
                                         <asp:Label ID="lblPatientName" runat="server" ></asp:Label>
                                   </td>
                                
                                   <td class="GridViewLabItemStyle"    style="width:16.66%;"  colspan="1"  >UHID</td>
                                   <td class="GridViewLabItemStyle"    style="width:33.33%;"  colspan="2"    >
                                         <asp:Label ID="lblUHID" runat="server" ></asp:Label>
                                   </td>
                                </tr>
                            <tr>
                                   <td class="GridViewLabItemStyle"     >Age </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblAge" runat="server" ></asp:Label>
                                   </td>
                                <td class="GridViewLabItemStyle"     >Sex </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblSex" runat="server" ></asp:Label>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >DOB </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblDOB" runat="server" ></asp:Label>
                                
                                   </td>
                                </tr>
                            
                            <tr>
                                   <td class="GridViewLabItemStyle"     >Specimen Collection Date </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:TextBox ID="txtSpecimenDate" CssClass="" runat="server"   ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtSpecimenDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                                                              </td>
                                <td class="GridViewLabItemStyle"     >Location of Collection(ward) </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtLocation" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >Specimen Anatomical Site (e.g. breast prostate soft tissue)</td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtAnatomical" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                
                                   </td>
                                </tr>
                            <tr>
                                   <td class="GridViewLabItemStyle"     > If More than One Site</td>
                                   <td class="GridViewLabItemStyle"     >
                                        <asp:TextBox ID="txtMore" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                
                                         </td>
                                <td class="GridViewLabItemStyle"     > </td>
                                   <td class="GridViewLabItemStyle"     >
                                         </td>
                                
                                <td class="GridViewLabItemStyle"     > </td>
                                   <td class="GridViewLabItemStyle"     >
                                         
                                   </td>
                                </tr>
                            
                            <tr>
                                
                                <td class="GridViewLabItemStyle"     >Specimen Type</td>
                                   <td class="GridViewLabItemStyle"   colspan="4"  >
                                       <asp:RadioButtonList ID="rdbSpecimenType" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >Surgical Resection</asp:ListItem>
                                          <asp:ListItem Value="1">Biopsy</asp:ListItem>
                                          <asp:ListItem Value="2">Core Needle Biopsy</asp:ListItem>
                                          <asp:ListItem Value="3">Fine Needle Aspirate/Cytology</asp:ListItem>
                                          <asp:ListItem Value="4">Pep Smear</asp:ListItem>
                                          <asp:ListItem Value="5">Other</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                   </td>
                                <td class="GridViewLabItemStyle"     >
                                        <asp:TextBox ID="txtOther" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                
                                         </td>
                                                                  </tr>
                           
                          <tr>
                                   <td class="GridViewLabItemStyle"  >Clinical notes/Summary
                           </td>
                              
                                <td class="GridViewLabItemStyle"   colspan="5"     >
                                        <asp:TextBox ID="txtSummary" CssClass="" runat="server" TextMode="MultiLine"   ClientIDMode="Static" ></asp:TextBox>
                                    </td>
                                
                              </tr>
                            
                          <tr>
                                   <td class="GridViewLabItemStyle"  > Impression
                           </td>
                              
                                <td class="GridViewLabItemStyle"   colspan="5"     >
                                        <asp:TextBox ID="txtImpression" CssClass="" runat="server" TextMode="MultiLine"   ClientIDMode="Static" ></asp:TextBox>
                                    </td>
                                
                              </tr>
                            
                          <tr>
                                   <td class="GridViewLabItemStyle"  > Special Request(e.g.stains or Immunohistochemistry)
                           </td>
                              
                                <td class="GridViewLabItemStyle"   colspan="5"     >
                                        <asp:TextBox ID="txtSpecial" CssClass="" runat="server" TextMode="MultiLine"   ClientIDMode="Static" ></asp:TextBox>
                                    </td>
                                
                              </tr>
                            
                          <tr>
                                   <td class="GridViewLabItemStyle"  > Name Of requesting clinical
                           </td>
                              
                                <td class="GridViewLabItemStyle"      >
                                        <asp:TextBox ID="txtRequesting" CssClass="" runat="server"   ClientIDMode="Static" disabled ></asp:TextBox>
                                    </td>
                                
                              </tr>
                          
                             </table>
                        
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                        
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
                <asp:GridView ID="grdPhysical" Visible="true" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Specimen">
                            <ItemTemplate>
                                <asp:Label ID="lblSpecimen" runat="server" Text='<%#Eval("Specimen1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Location ">
                            <ItemTemplate>
                                <asp:Label ID="lblLocation" runat="server" Text='<%#Eval("Location") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="More">
                            <ItemTemplate>
                                <asp:Label ID="lblMore" runat="server" Text='<%#Eval("More") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ANormalPower1"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblSpecimenType" runat="server" Text='<%#Eval("SpecimenType") %>'></asp:Label>
                                <asp:Label ID="lblSite" runat="server" Text='<%#Eval("Site") %>'></asp:Label>
                                <asp:Label ID="lblOther" runat="server" Text='<%#Eval("Other") %>'></asp:Label>
                                <asp:Label ID="lblSummary" runat="server" Text='<%#Eval("Summary") %>'></asp:Label>
                                <asp:Label ID="lblImpression" runat="server" Text='<%#Eval("Impression") %>'></asp:Label>
                                <asp:Label ID="lblSpecial" runat="server" Text='<%#Eval("Special") %>'></asp:Label>
                                </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        

                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID1" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="170" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Transaction ID" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("TransactionID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry By" Visible="true">
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


