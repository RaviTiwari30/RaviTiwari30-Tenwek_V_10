<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="VehicleDashBoard.aspx.cs" Inherits="Design_Transport_VehicleDashBoard" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {

            $.ajax({
                url: "Services/Transport.asmx/bindDashBoard",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async:false,
                dataType: "json",
                success: function (result) {
                    VehicleInfo = $.parseJSON(result.d);
                    if (VehicleInfo != null && VehicleInfo != "0") {
                        var HtmlOutput = $("#scriptDashBoard").parseTemplate(VehicleInfo);
                        $("#divDashBoard").html(HtmlOutput);
                        $("#divDashBoard").show();                        
                    }
                    else {
                        $("#divDashBoard").html("");                        
                        DisplayMsg("MM04", "lblErrorMsg");
                    }
                },
                error: function (xhr, status) {
                }
            });

        });
    </script>
    <div id="Pbody_box_inventory">
        <div style="text-align: center;">
            <b><span id="lblHeader" style="font-weight: bold;">Vehicle Status Report</span></b><br />
            <span id="lblErrorMsg" class="ItDoseLblError"></span>            
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <div id="divDashBoard" style="height:500px;overflow:auto">                
            </div>
        </div>
    </div>
    <script type="text/html" id="scriptDashBoard">
          <table width="100%">
            <tr>                                              
                 <td colspan="5">&nbsp;</td>                        
            </tr>
            <tr>                
                <td style="width:20%;text-align:right;border-top:0;">Vehicle In :&nbsp;</td>
                <td style="width:30%;text-align:left;background-color:red"></td>
                <td style="width:10%;text-align:right;">Vehicle Out :&nbsp;</td>
                <td style="width:30%;text-align:left;background-color:green"></td> 
                <td style="width:10%;">&nbsp;</td>                                                  
            </tr>
            <tr>                                              
                 <td colspan="5">&nbsp;</td>                        
            </tr>
          </table>
          <table width="100%" cellspacing="0" rules="all" border="1" style="border-collapse: collapse;" >
            <tr>                
                <td style="width:20%;text-align:right;"><strong>Vehicle Name</strong></td>
                <td style="width:30%;text-align:left;"><strong>Current Status</strong></td>
                <td style="width:10%;text-align:right;"></td>
                <td style="width:40%;text-align:left;"><strong>Last Out Status</strong></td>                                                    
            </tr>
            <#
                var dataLength=VehicleInfo.length;
		        window.status="Total Records Found :"+ dataLength;
		        var objRow;   
		        for(var j=0;j<dataLength;j++)
		        {
                    var CurrentStatus="";
                    var LastStatus="";
                    var NextServiceDate="";
                    objRow=VehicleInfo[j];
                    if(objRow.CurrentStatus!="IN")
                    {
                        CurrentStatus="<span style='color:red'><strong>Out&nbsp;</strong>Date Time :&nbsp"+ objRow.CurrentStatus.split("#")[0]+"<br/><strong>Purpose :&nbsp;</strong>"+objRow.CurrentStatus.split("#")[1]+"</span>";
                    }
                    else
                    {
                        CurrentStatus="<span style='color:green'><strong>IN</strong><br/></span>";
                    }

                    if(objRow.LastStatus!=null && objRow.LastStatus!="")
                    {
                        LastStatus="<strong>Date Time :&nbsp</strong>"+objRow.LastStatus.split("#")[0]+"<br/><strong>Purpose :&nbsp;</strong>"+objRow.LastStatus.split("#")[1]+"</span><br/>";
                    }

                    if(objRow.NextServiceDate!=null &&  objRow.NextServiceDate!="")
                    {
                        NextServiceDate="<strong>Next Service Date :&nbsp</strong>"+objRow.NextServiceDate+"";
                    }

            #>
                    <tr style="border:1px solid black;">                                              
                        <td style="width:20%;text-align:right;"><#=objRow.VehicleName#></td>
                        <td style="width:30%;text-align:left;"><#=CurrentStatus#></td>
                        <td style="width:10%;text-align:right;"></td>
                        <td style="width:40%;text-align:left;"><#=LastStatus#><#=NextServiceDate#></td>                        
                    </tr> 
                    <tr>                                              
                        <td colspan="5">&nbsp;</td>                        
                    </tr>                          
            <#    
                }                
            #>
        </table>
    </script>
</asp:Content>

