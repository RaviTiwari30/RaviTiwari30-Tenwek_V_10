<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FileStatus.aspx.cs" Inherits="Design_MRD_FileStatus" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <script  type="text/javascript" src="../../Scripts/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script  src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script  src="../../Scripts/jquery.tablednd.js" type="text/javascript"></script>
    <link href="../../Styles/framestyle.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            Filestatus('ALL');
            $(".All").mouseover(function () {
                Filestatus('ALL');
            });
            $('.Green').mouseover(function () {
                Filestatus('A');
            });
            $('.Yellow').mouseover(function () {
                Filestatus('B');
            });
            $('.Blue').mouseover(function () {
                Filestatus('C');
            });
            $('.Red').mouseover(function () {
                Filestatus('D');
            });



        });
        function Filestatus(status) {
            var TransactionID = '<%=Util.GetString(Request.QueryString["TID"])%>';
            var PatientID = '<%=Util.GetString(Request.QueryString["PatientID"])%>';
            var type = '<%=Util.GetString(Request.QueryString["Type"])%>';
            $.ajax({
                url: "../MRD/Services/ICDAutoComplete.asmx/GetFileStatus",
                data: '{TransactionID: "' + TransactionID + '",Status: "' + status + '",PatientID:"' + PatientID + '",type:"' + type + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    obsData = jQuery.parseJSON(result.d);
                    var output = $('#tb_InvestigationItems').parseTemplate(obsData);
                    $('#ShowFile').html(output);
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });


        }

    </script>
    
</head>
<body>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory" style="margin-top:0px;">
        <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>File Status<br />
                    </b>
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" EnableViewState="False" />
        </div>
        <div class="POuter_Box_Inventory">          
                <asp:Panel ID="pnlIpd" runat="server" Visible="false">
                    <table style="width: 881px; height: 60px">
                        <tr>
                            <td align="right" style="width: 193px; height: 18px">
                                Patient Type :&nbsp;
                            </td>
                            <td align="left" style="width: 301px; height: 18px;">
                                <asp:Label ID="lblPatientType" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="width: 301px; height: 18px;">
                            </td>
                            <td align="right" style="width: 300px; height: 18px;">
                                Patient Name :&nbsp;
                            </td>
                            <td align="left" style="width: 300px; height: 18px;">
                                <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 193px; height: 18px">
                                MLC Number :&nbsp;
                            </td>
                            <td align="left" style="width: 301px; height: 18px;">
                                <asp:Label ID="lblMLCNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="width: 301px; height: 18px;">
                            </td>
                            <td align="right" style="width: 300px; height: 18px;">
                                Bill No. :&nbsp;
                            </td>
                            <td align="left" style="width: 300px; height: 18px;">
                                <asp:Label ID="lblBillNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 193px; height: 18px">
                                Discharge Date :&nbsp;
                            </td>
                            <td align="left" style="width: 301px; height: 18px;">
                                <asp:Label ID="lblDischargeDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="width: 301px; height: 18px;">
                            </td>
                            <td align="right" style="width: 193px; height: 18px">
                             IPD No. :&nbsp;
                            </td>
                            <td style="width: 300px; height: 18px;">
                            <%-- <em><span style="color: #0000ff; font-size: 9.5pt">(Mouseover to see result)</span></em>--%>
                                <asp:Label ID="lblCRNumber" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    </asp:Panel>
                     <asp:Panel ID="pnlOpd" runat="server" Visible="false">
               <table>
               <tr>
               <td style="width: 200px; text-align: right;">
               UHID :&nbsp;
               </td>
               <td align="left" style="width: 200px">
               <asp:Label ID="lblMRno" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
               </td>
               <td style="width: 200px; text-align: right;">Patient Name :&nbsp;
              </td>
               <td>
                <asp:Label ID="lblPnatientnameOpd" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
               </td>
               </tr>
               
               </table> 
                
                
                
                </asp:Panel>
              
                <div class="pHeaderTab">
                    <table style="text-align:center;border-collapse:collapse">
                        <tr>
                            <td  style="height: 18px; background-color: #F778A1; text-align: center;
                                width: 193px;" title="Mouseover" class="All" runat="server">
                                <strong>
                                    <label>
                                        ALL</label>
                                </strong>&nbsp;<br />
                               
                            </td>
                            <td style="text-align: center; background-color: #64E986; height: 18px;
                                width: 301px;" title="Mouseover" class="Green">
                                <strong>
                                    <label>
                                    </label>
                                    &nbsp;</strong> &nbsp;<strong>Received and Completed</strong>&nbsp;
                                
                            </td>
                            <td  style="text-align: center; background-color: #6699FF;
                                height: 18px; width: 301px;" title="Mouseover" class="Yellow">
                                <label>
                                </label>
                                <strong>Received and InComplete&nbsp;</strong>
                              

                            </td>
                            <td  style="text-align: center; background-color: #FFA500; height: 18px;
                                width: 300px;" title="Mouseover" class="Blue">
                                <label>
                                </label>
                                <strong>Document Not Received</strong>
                               
                            </td>
                            <td  style="text-align: center; background-color: #F75D59; height: 18px;
                                width: 300px;" title="Mouseover" class="Red">
                                <strong>
                                    <label>
                                        Document Not Required</label>&nbsp;</strong>
                               
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div>
              
            </div>
            <div id="ShowFile" style="text-align:center">
        </div>
        
        
    </div>
    <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="FileStatusGrid" style="border-collapse:collapse;width:100%;">
		<tr class="nodrop">
        <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">File No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">IPD No.</th>
	        <th class="GridViewHeaderStyle" scope="col" style="width:150px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Room Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Rack</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:250px;">Document</th>				
         </tr>
       <#       
              var dataLength=obsData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = obsData[j];        
            #>              
              <tr  >
             <#if(objRow.Status=='A'){#>
             <td class="GridViewLabItemStyle" style="background-color:#64E986"><#=j+1#></td>              
<td class="GridViewLabItemStyle" style="background-color:#64E986"><#=objRow.FileID#></td>
<td class="GridViewLabItemStyle" style="background-color:#64E986"><#=objRow.TransNO#></td>
<td class="GridViewLabItemStyle" style="background-color:#64E986" align="center"><#=objRow.PID#></td>
<td class="GridViewLabItemStyle" style="background-color:#64E986"><#=objRow.RoomName#></td>
<td class="GridViewLabItemStyle" style="background-color:#64E986"><#=objRow.Almirah#></td>
<td class="GridViewLabItemStyle" style="background-color:#64E986" align="left"><#=objRow.Document#></td>
<#} else if(objRow.Status=='B') {#>
<td class="GridViewLabItemStyle" style="background-color:#6699FF"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="background-color:#6699FF"><#=objRow.FileID#></td>
<td class="GridViewLabItemStyle" style="background-color:#6699FF"><#=objRow.TransNO#></td>
<td class="GridViewLabItemStyle" style="background-color:#6699FF" align="center"><#=objRow.PID#></td>
<td class="GridViewLabItemStyle" style="background-color:#6699FF"><#=objRow.RoomName#></td>
<td class="GridViewLabItemStyle" style="background-color:#6699FF"><#=objRow.Almirah#></td>
<td class="GridViewLabItemStyle" style="background-color:#6699FF" align="left"><#=objRow.Document#></td>
<#} else if(objRow.Status=="C") {#>
<td class="GridViewLabItemStyle" style="background-color:#FFA500"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="background-color:#FFA500"><#=objRow.FileID#></td>
<td class="GridViewLabItemStyle" style="background-color:#FFA500"><#=objRow.TransNO#></td>
<td class="GridViewLabItemStyle" style="background-color:#FFA500" align="center"><#=objRow.PID#></td>
<td class="GridViewLabItemStyle" style="background-color:#FFA500"><#=objRow.RoomName#></td>
<td class="GridViewLabItemStyle" style="background-color:#FFA500"><#=objRow.Almirah#></td>
<td class="GridViewLabItemStyle" style="background-color:#FFA500" align="left"><#=objRow.Document#></td>
<#} else {#>
<td class="GridViewLabItemStyle" style="background-color:#F75D59"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="background-color:#F75D59"><#=objRow.FileID#></td>
<td class="GridViewLabItemStyle" style="background-color:#F75D59"><#=objRow.TransNO#></td>
<td class="GridViewLabItemStyle" style="background-color:#F75D59" align="center"><#=objRow.PID#></td>
<td class="GridViewLabItemStyle" style="background-color:#F75D59"><#=objRow.RoomName#></td>
<td class="GridViewLabItemStyle" style="background-color:#F75D59"><#=objRow.Almirah#></td>
<td class="GridViewLabItemStyle" style="background-color:#F75D59" align="left"><#=objRow.Document#></td>
<#}#>

<#}#>
</tr>
        </table>    
    </script>
    </form>
</body>
</html>
