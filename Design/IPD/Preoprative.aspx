<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Preoprative.aspx.cs" Inherits="Design_IPD_Preoprative" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>   
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
     <script type="text/javascript">
          </script>

    <form id="form1" runat="server">

        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Pre-Operative Checklist</b>
                <br />
             </div>   
            
        
            <div class="POuter_Box_Inventory">
            <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <%--<label class="pull-left"><b>PREOPERATIVE CHECK </b> </label>--%>                                
                      </div>
                      <div class="col-md-8">                                   
                      </div>                           
                      <div class="col-md-3" style="display:none" >
                                    <label><b>YES</b></label>
                                    <label><b>NO</b></label> 
                      </div>
                      <div class="col-md-8">
                                    <label><b>Comment Ward</b></label>
                      </div>
                      <div class="col-md-3" style="display:none">
                                    <label><b>YES</b></label>
                                    <label><b>NO</b></label>
                       </div>
                       <div class="col-md-5">           
                                   <label><b>Comment OT</b></label> 
                       </div>
                    </div>
                 </div>
            <div class="row">
                 <div class="col-md-24">
                      <div class="col-md-3">
                                 <label class="pull-left"><b>A GENERAL</b> </label>                                
                      </div>                      
                    </div>
                </div>
            <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">1 NPO Since </label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtNPOSlice" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="NPO SLice"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbNPOSliceYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                                              </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtNPOSliceNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbNPOSliceYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtNPOSliceComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">2 Identification Band</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtIndificationBrand" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Indification Brand"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbIndificationBrandYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtIndificationBrandNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbIndificationBrandYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtIndificationBrandComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div> 
                 <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">3 Theatre Gown</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtTheatreGown" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Theatre Gown"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbTheatreGownYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtTheatreGownNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbTheatreGownYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtTheatreGownComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>   
                <div class="row">
                 <div class="col-md-24">
                      <div class="col-md-3">
                                <label class="pull-left">4 Known Allergies</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtKnownAllergies" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="known Allergies"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbKnownAllergiesYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtKnownAllergiesNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbKnownAllergiesYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtKnownAllergiesComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                </div>
                <div class="row">
                 <div class="col-md-24">
                      <div class="col-md-3">
                                 <label class="pull-left">(If yes, indicate in comment) </label>                                
                      </div>                      
                    </div>
                </div>
                <div class="row">
                 <div class="col-md-24">
                      <div class="col-md-3">
                                <label class="pull-left">5 Personal Effects</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtPersonalEffects" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Personal Effects"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbPersonalEffectsYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtPersonalEffectsNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbPersonalEffectsYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtPersonalEffectsComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                </div>
                <div class="row" style="display:none">
                 <div class="col-md-24">
                      <div class="col-md-3">
                                 <label class="pull-left">Known As Watch,Money,Wig </label>                                
                      </div>                      
                    </div>
                </div>
                <div class="row">
                 <div class="col-md-24">
                      <div class="col-md-3">
                                <label class="pull-left">6 Dentures</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtDentures" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Dentures"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbDenturesYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtDenturesNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbDenturesYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtDenturesComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                </div>
                <div class="row">
                 <div class="col-md-24">
                      <div class="col-md-3">
                                 <label class="pull-left"><b>B SPECIFIC</b> </label>                                
                      </div>                      
                    </div>
                </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">1 Intravenous Drip</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtIntravenousDrip" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Intravenous Drip"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbIntravenousDripYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>  
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtIntravenousDripNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbIntravenousDripYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtIntravenousDripComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">2 Skin Preparation</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtSkinPreparation" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Skin preperation"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbSkinPreparationYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtSkinPreparationNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbSkinPreparationYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtSkinPreparationComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div> 
                 <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">3 Nasogastric Tube</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtNasogaticTube" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Nasogatic Tube"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbNasogaticTubeYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtNasogaticTubeNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbNasogaticTubeYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtNasogaticTubeComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">(If Ordered)</label>
                      </div>
                 </div>
                </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">4 Bowel Prep</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtBowelPrep" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Bowel prep"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbBowelPrepYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtBowelPrepNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbBowelPrepYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtBowelPrepComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">(If Ordered)</label>
                      </div>
                 </div>
                </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">5 Urinary Catheter</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtUrinaryCatheter" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="urinary catheter"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbUrinaryCatheterYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtUrinaryCatheterNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbUrinaryCatheterYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtUrinaryCatheterComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">(If Ordered)</label>
                      </div>
                 </div>
                </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">6 Bladder emptied</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtBladderemptied" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="bladder emptied"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbBladderemptiedYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>  
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtBladderemptiedNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbBladderemptiedYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtBladderemptiedComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">(If no Catheter in SITU)</label>
                      </div>
                 </div>
                </div>  
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">7 Premedication Ordered</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtPremedicationOrdered" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="premedicationOrdered"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbPremedicationOrderedYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtPremedicationOrderedNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbPremedicationOrderedYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtPremedicationOrderedComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>  
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">Patient Record</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtPatientRecord" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Patient Record"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbPatientRecordYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtPatientRecordNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbPatientRecordYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtPatientRecordComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">8 Consent Form</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtConsentForm" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="consent Form"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbConsentFormYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>  
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtConsentFormNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbConsentFormYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtConsentFormComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">Charts available</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtChartsavailable" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Charts available"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbChartsavailableYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>  
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtChartsavailableNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbChartsavailableYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtChartsavailableComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">Patient admitted</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtPatientadmitted" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="patient admitted"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbPatientadmittedYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtPatientadmittedNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbPatientadmittedYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtPatientadmittedComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">9 Latest Vital Sign</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtLatestVitalSign" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Latest vital Sign"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbLatestVitalSignYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtLatestVitalSignNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbLatestVitalSignYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtLatestVitalSignComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">BP</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtBPPR" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="BP/PR"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbBPPRYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtBPPRNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbBPPRYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtBPPRComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">PR</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtPR1" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="BP/PR"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbPR1" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtPRComment1" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbPR2" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtPRComment2" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">Temp.</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtTempSAT" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Temp/SAT"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbTempSATYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtTempSATNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbTempSATYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtTempSATComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">SAT.</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtSAT" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Temp/SAT"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbSAT1" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtSATComment1" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbSAT2" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtSATComment2" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">Resp.</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtResp" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Resp"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbRespYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtRespNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbRespYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtRespComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">10 Weight in Kg</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtWeightinKg" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Weight in Kg"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbWeightinKgYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtWeightinKgNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbWeightinKgYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtWeightinKgComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">11 L.M.P for female Patient(dd/mm/yy)</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtLMPforfemalePatient" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="LMP"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbLMPforfemalePatientYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtLMPforfemalePatientNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbLMPforfemalePatientYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtLMPforfemalePatientComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24">
                      <div class="col-md-3">
                                 <label class="pull-left"><b>C LABS</b> </label>                                
                      </div>                      
                    </div>
                </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">1 Last Hb</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtLastHb" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Last Hb"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbLastHbYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtLastHbNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbLastHbYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtLastHbComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">2 Blood Ordered</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtBloodOrdered" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Blood Ordered"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbBloodOrderedYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtBloodOrderedNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbBloodOrderedYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtBloodOrderedComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">3 Other Lab Test</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtOtherLabTest" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Other Lab test"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbOtherLabTestYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtOtherLabTestNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbOtherLabTestYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtOtherLabTestComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">Na+</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtNaPlus" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Na+"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbNaPlusYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtNaPlusNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbNaPlusYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtNaPlusComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">K+</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtKPlus" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="K+"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbKPlusYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtKPlusNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbKPlusYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtKPlusComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">Creatinine</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtCreatine" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="creatine"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbCreatineYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtCreatineNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbCreatineYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtCreatineComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24">
                      
                                 <label class="pull-left"><b>D NON SPECIFIC</b> </label>                                
                                            
                    </div>
                </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">1 Chronic alcohol intake</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtChronicalcoholintake" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="chronical alcohol intake"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbChronicalcoholintakeYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtChronicalcoholintakeNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbChronicalcoholintakeYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtChronicalcoholintakeComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">2 Chronic Smoker</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtChronicSmoker" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="chronic smoker"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbChronicSmokerYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtChronicSmokerNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbChronicSmokerYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtChronicSmokerComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">3 Medication(if yes,indicate in comment section)</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtMedication" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="medication"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbMedicationYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>  
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtMedicationNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbMedicationYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtMedicationComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
                <div class="row" style="display:none">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left"></label>
                                
                      </div>
                      <div class="col-md-5">
                                   <label><b>YES</b></label>
                                   <label><b>NO</b></label>
                      </div>                           
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-5">
                                <label class="pull-left">Antibiotics</label>
                                
                      </div>
                      <div class="col-md-5">
                                    <asp:RadioButtonList ID="rdbAntibioticsYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>                           
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-5">
                                <label class="pull-left">Anti-hypertensive Therapy</label>
                                
                      </div>
                      <div class="col-md-5">
                                    <asp:RadioButtonList ID="rdbAntipertensivetherapyYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>                           
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-5">
                                <label class="pull-left">Anticoagulant Therapy</label>
                                
                      </div>
                      <div class="col-md-5">
                                    <asp:RadioButtonList ID="rdbAnticoagulantTherapyYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>                           
                    </div>
                 </div>
                <div class="row">
                 <div class="col-md-24"> 
                      <div class="col-md-5">
                                <label class="pull-left">Insulin/Oral Hypoglycemic</label>
                                
                      </div>
                      <div class="col-md-5">
                                    <asp:RadioButtonList ID="rdbInsulinOralhypoglycemicYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList> 
                      </div>                           
                    </div>
                 </div>
                <div class="row" style="display:none;">
                 <div class="col-md-24"> 
                      <div class="col-md-3">
                                <label class="pull-left">4 Time Recieved in the OR</label>
                                <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtTimeRecievedintheOR" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Time recieved in the OR"></asp:TextBox>
                      </div>                           
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbTimeRecievedintheORYesNoNurse" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                      </div>
                      <div class="col-md-5">
                                    <asp:TextBox ID="txtTimeRecievedintheORNurseComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                      </div>
                      <div class="col-md-3">
                                    <asp:RadioButtonList ID="rdbTimeRecievedintheORYesNo" runat="server" RepeatDirection="Horizontal">
                                          <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                      </asp:RadioButtonList>
                       </div>
                       <div class="col-md-5">           
                                    <asp:TextBox ID="txtTimeRecievedintheORComment" runat="server"  Width="130px" ClientIDMode="Static" maxLength="100" ToolTip="Comment"></asp:TextBox>
                       </div>
                    </div>
                 </div>
        </div>
            <div class="POuter_Box_Inventory">               
                <div class="row">
                    <div class="col-md-24">
                        <div style="font-family:Arial;color:blue;">
                            <div class="col-md-3">
                                <label class="pull-left">Last Updated By:</label>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lblLastUpdatedBy" runat="server" Visible="true"></asp:Label>
                            </div>
                            <div class="col-md-2">
                                DateTime:
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblLastUpdatedDate" runat="server" Visible="true"></asp:Label>
                                <asp:Label ID="lblLastUpdatedTime" runat="server" Visible="true"></asp:Label>
                            </div>
                        </div>  
                        <div class="col-md-10" style="text-align:left">
                            <asp:Label ID="lblPID" runat="server" Visible="false"></asp:Label>
                            <%-- <asp:Button ID="btnSubmit" runat="server"  CssClass="ItDoseButton" Text="Save" ToolTip="Click To Save"  OnClick="btnSubmit_Click"  />--%>
                            <asp:Button ID="btnUpdate" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Update" ToolTip="Click To Update" CausesValidation="false" Visible="false" OnClick="btnUpdate_Click" />
                            <asp:Button ID="btnCancel" TabIndex="7" runat="server" Text="Cancel" CssClass="ItDoseButton" Visible="false" OnClick="btnCancel_Click" CausesValidation="false" />
                            <asp:Button ID="btnSave" type="submit" runat="server" Text="Save" OnClick="btnSubmit_Click" CausesValidation="false" />
                        </div>                        
                    </div>
                </div>                
            </div>        
            </div>
        
    </form>
</body>
</html>
