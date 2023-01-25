<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PartographChart.aspx.cs" Inherits="Design_IPD_PartographChart" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register TagPrefix="asp" Namespace="System.Web.UI" Assembly="System.Web"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../Styles/jquery-ui.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
     <script type="text/javascript">
         google.load('visualization', '1', { packages: ['corechart'] });
         google.load('visualization', '1', { packages: ['table'] });
    </script>

    <script type="text/javascript">
        $(document).ready(function () {
            BindFHR_graph();
            BindCervixDescent_graph();
            BindContractions_graph();
           
        })
       
        function print1() {
            var IPDNo = "<%=ViewState["IPDNO"].ToString()%>";
            var EMGNo = "<%=ViewState["EMGNo"].ToString()%>";
            var printContents = '<div style="text-align: center" class="POuter_Box_Inventory"><b>Vital Sign Chart</b></br> ';
            if (IPDNo != '')
                printContents += '<b>IPD No. : ' + IPDNo + '</b> ';
            else
                printContents += '<b>Emenegency No. : ' + EMGNo + '</b>';
            printContents += '</div>';
            printContents += document.getElementById('printData').innerHTML;
            var originalContents = document.body.innerHTML;

            document.body.innerHTML = printContents;

            window.print();

            document.body.innerHTML = originalContents;
        }

        function BindFHR_graph() {
            var TID = "<%=Request.QueryString["TransactionID"]%>";
             $.ajax({
                 url: "PartographChart.aspx/BindFHR_graph",
                 data: '{TID:"' + TID + '"}',
                 type: "POST",
                 async: true,
                 dataType: "json",
                 contentType: "application/json; charset=utf-8",
                 success: function (mydata) {
                     var mis_data = jQuery.parseJSON(mydata.d);
                     if (mis_data.length > 0) {
                         var dataTable = new google.visualization.DataTable();
                         dataTable.addColumn('string', 'CreatedTime');
                         dataTable.addColumn('number', 'FHR');

                         dataTable.addRows(mis_data.length);
                         for (var i = 0; i < mis_data.length; i++) {
                             dataTable.setCell(i, 0, mis_data[i].CreatedTime);
                             dataTable.setCell(i, 1, mis_data[i].FHR);
                         }

                         new google.visualization.ComboChart(document.getElementById('bindFHR_Area')).
                       draw(dataTable,
                            {
                                title: 'Fetal Heart Rate', fontName: '"Arial"',
                                // width: 850,
                                height: 400,

                                hAxis: { title: "DateTime" },
                                seriesType: "line",
                               // seriesType: "bars",
                               // series: { 2: { type: "line" } }
                            }

                       );
                         $('#bindFHR_Area').show();
                     }
                     else
                         $('#bindFHR_Area').hide();
                 }
             });
         }

        function BindCervixDescent_graph() {
            var TID = "<%=Request.QueryString["TransactionID"]%>";
              $.ajax({
                  url: "PartographChart.aspx/bindCervixDescent_graph",
                  data: '{TID:"' + TID + '"}',
                  type: "POST",
                  async: true,
                  dataType: "json",
                  contentType: "application/json; charset=utf-8",
                  success: function (mydata) {
                      var mis_data = jQuery.parseJSON(mydata.d);
                      if (mis_data.length > 0) {
                          var dataTable = new google.visualization.DataTable();
                          dataTable.addColumn('string', 'CreatedTime');                         
                          dataTable.addColumn('number', 'Cervix');
                          dataTable.addColumn('number', 'Descent');
                          dataTable.addColumn('number', 'Alert');
                          dataTable.addColumn('number', 'Action');
                          dataTable.addRows(mis_data.length);
                          for (var i = 0; i < mis_data.length; i++) {                            
                                 dataTable.setCell(i, 0, mis_data[i].CreatedTime);
                              if (mis_data[i].Cervix != 0)
                                 dataTable.setCell(i, 1, mis_data[i].Cervix);
                              if (mis_data[i].Descent != 0)
                                 dataTable.setCell(i, 2, mis_data[i].Descent);
                              if (mis_data[i].Alert != 0)
                                 dataTable.setCell(i, 3, mis_data[i].Alert);
                              if(mis_data[i].Action != 0)
                                  dataTable.setCell(i, 4, mis_data[i].Action);
                          }

                          new google.visualization.ComboChart(document.getElementById('bindCervixDescent_Area')).
                        draw(dataTable,
                             {
                                 title: 'Cervix & Descent', fontName: '"Arial"',
                                 // width: 850,
                                 height: 400,

                                 hAxis: { title: "Time" },
                                 seriesType: "line",
                             }

                        );
                          $('#bindCervixDescent_Area').show();
                      }
                      else
                          $('#bindCervixDescent_Area').hide();
                  }
              });
          }

        function BindContractions_graph() {
            var TID = "<%=Request.QueryString["TransactionID"]%>"; 
            $.ajax({                
                url: "PartographChart.aspx/bindContractions_graph",
                data: '{TID:"' + TID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'CreatedTime');
                        dataTable.addColumn('number', '_20sec');
                        dataTable.addColumn('number', '_20_40sec');
                        dataTable.addColumn('number', '_40sec');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].CreatedTime);
                            dataTable.setCell(i, 1, mis_data[i]._20sec);
                            dataTable.setCell(i, 2, mis_data[i]._20_40sec);
                            dataTable.setCell(i, 3, mis_data[i]._40sec);
                        }

                        new google.visualization.ComboChart(document.getElementById('bindContractions_Area')).
                      draw(dataTable,
                           {
                               title: 'Contractions', fontName: '"Arial"',                               
                               // width: 850,
                               height: 400,

                               hAxis: { title: "DateTime" },
                               seriesType: "bars",                              
                           }

                      );
                        $('#bindContractions_Area').show();
                    }
                    else
                        $('#bindContractions_Area').hide();
                }
            });
        }


    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div style="text-align: center" class="POuter_Box_Inventory">
                <b>Partograph Chart</b>
                <br />
                   <asp:Label ID="lblMsg" runat="server" ForeColor="Red" Font-Size="Large"></asp:Label>
                   <input type="button" id="btnPrint" onclick="print1()" value="Print" style="margin-left:95%;" />               
            </div>
            <div id="printData">
               <div class="POuter_Box_Inventory">
                        <div class="Purchaseheader">Fetal Heart Rate</div>
                        <table style="width:100%">
                             <tr>
                                <td style="width: 50%">
                                    <div id="bindFHR_Area">
                                    </div>
                                </td>                           
                            </tr>
                       </table>
                </div> 

                 <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">CERVIX AND DESCENT</div>
                    <table style="width:100%">
                         <tr>
                            <td style="width: 50%">
                                <div id="bindCervixDescent_Area">
                                </div>
                            </td>                           
                        </tr>
                   </table>
               </div>
                       
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">Contractions</div>
                    <table style="width:100%">
                         <tr>
                            <td style="width: 50%">
                                <div id="bindContractions_Area">
                                </div>
                            </td>                           
                        </tr>
                   </table>
               </div>
                <div class="POuter_Box_Inventory">
                    
                    <div class="row">
                    <div class="col-md-24">
                        
                        <%--<table style="width:700px;" class="FixedTables" >
                           
                        --%>
                         <div style="overflow: scroll;">
                        <table style="width:700px;" class="" >
                            <tr  class="Purchaseheader">
                                <th colspan="7" >Summary Of Labour</th>
                                <th colspan="4">Total duration Of labour</th>
                            </tr>
                            <tr>
                                  <td class="GridViewLabItemStyle"  >1<sup>st</sup>Stage</td>

                                  <td class="GridViewLabItemStyle"  >Induction Of Labour
                                    

                                  </td>
                                <td class="GridViewLabItemStyle"  >
                                      <asp:RadioButtonList ID="rdbInduction" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                  </td>
                                <td class="GridViewLabItemStyle"  >Duration
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                     <asp:TextBox ID="txtDuration" CssClass="" runat="server" width="100px"   ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >No Of VE
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                     <asp:TextBox ID="txtNoOfVE" CssClass="" runat="server"  width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >Hours
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                     <asp:TextBox ID="txtHours" CssClass="" runat="server"  width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >Mins
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                     <asp:TextBox ID="txtMins" CssClass="" runat="server"  width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                            </tr>
                             <tr>
                                  <td class="GridViewLabItemStyle"  >2<sup>nd</sup> Stage</td>

                                  <td class="GridViewLabItemStyle"  >
                                    

                                  </td>
                                <td class="GridViewLabItemStyle"  >Mode Of Delivery
                                     
                                  </td>
                                <td class="GridViewLabItemStyle"  >
                                    <asp:TextBox ID="txtModeOfDelivery" CssClass="" runat="server"  width="100px"     ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                     Duration
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                         <asp:TextBox ID="txtDutation1" CssClass="" runat="server"  width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                mins
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                    
                                    </td>
                            </tr>
                            <tr>
                                  <td class="GridViewLabItemStyle" rowspan="6"  >3<sup>rd</sup> Stage</td>

                                  <td class="GridViewLabItemStyle"  >
                                    AMTSL

                                  </td>
                                <td class="GridViewLabItemStyle"  > 
                                    <asp:RadioButtonList ID="rdbAMTSL" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                  </td>
                                <td class="GridViewLabItemStyle"  >
                                    Uterotonic Oxytocin/Other
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                    <asp:TextBox ID="txtUterotonic" CssClass="" runat="server"  width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                         Duration Of Third Stage
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                               <asp:TextBox ID="txtDurationOfThirdStage" CssClass="" runat="server" width="100px"   ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                    
                                    </td>
                            </tr>
                            <tr>
                                  
                                  <td class="GridViewLabItemStyle"  >
                                    Baby  <asp:RadioButtonList ID="rdbAlive" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="alive" >alive</asp:ListItem>
                                          <asp:ListItem Value="SB">SB</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
  <asp:RadioButtonList ID="rdbM" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="M" >M</asp:ListItem>
                                          <asp:ListItem Value="F">F</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    

                                  </td>
                                <td class="GridViewLabItemStyle"  >    Apgar Score 1Min
                                   <asp:TextBox ID="txtApgarScore1Min" CssClass="" runat="server"  width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                  </td>
                                <td class="GridViewLabItemStyle"  >
                                    5 min
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                    <asp:TextBox ID="txtApgarScore5Min" CssClass="" runat="server"  width="100px"      ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                         10 min <asp:TextBox ID="txtApgarScore10Min" CssClass="" runat="server"  width="100px"      ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                              Resusation  
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                     <asp:RadioButtonList ID="rdbResusation" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                    </td>
                                <td class="GridViewLabItemStyle"  >Duration
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                     <asp:TextBox ID="txtDuration3" CssClass="" runat="server"    width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                <td class="GridViewLabItemStyle"  >mins
                                    
                                    </td>
                            </tr>
                           <tr>
                                  
                                  <td class="GridViewLabItemStyle"  >
                                    Placenta </td> <td class="GridViewLabItemStyle"  > <asp:RadioButtonList ID="rdbPlacenta" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="Complete" >Complete</asp:ListItem>
                                          <asp:ListItem Value="Incomplete">Incomplete</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                  </td>
                                <td class="GridViewLabItemStyle"  > 
                                   <asp:TextBox ID="txtPlacenta" CssClass="" runat="server"    width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                  </td>
                                <td class="GridViewLabItemStyle"  >
                                    Membranes  </td> <td class="GridViewLabItemStyle"  > <asp:RadioButtonList ID="rdbMembranes" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="Complete" >Complete</asp:ListItem>
                                          <asp:ListItem Value="Incomplete">Incomplete</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                    <asp:TextBox ID="txtMembranes" CssClass="" runat="server"  width="100px"      ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                        Cord  </td> <td class="GridViewLabItemStyle"  >
                                     <asp:RadioButtonList ID="rdbCord" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="Normal" >Normal</asp:ListItem>
                                          <asp:ListItem Value="Abnormal">Abnormal</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                    
                                    </td>
                                <td class="GridViewLabItemStyle"  > placenta Wt </td> <td class="GridViewLabItemStyle"  >
                                <asp:TextBox ID="txtPlacentaWt" CssClass="" runat="server"  width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                
                                                           </tr>
                            <tr>
                                  
                                  <td class="GridViewLabItemStyle"  >
                                    Est. Blood Loss

                                  </td>
                                <td class="GridViewLabItemStyle"  > 
                                   <asp:TextBox ID="txtEstBloodLoss" CssClass="" runat="server"  width="100px"      ClientIDMode="Static" ></asp:TextBox>
                                
                                  </td>
                                <td class="GridViewLabItemStyle"  >
                                  m/s
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                   Pevineal Tear Episio repair
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                         <asp:RadioButtonList ID="rdbDevinial" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                    </td>
                                <td class="GridViewLabItemStyle"  >Mother BP
                                
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                    <asp:TextBox ID="txtBP1" CssClass="" runat="server"  width="100px"      ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                <td class="GridViewLabItemStyle"  >Pulse
                                    <asp:TextBox ID="txtPulse1" CssClass="" runat="server"  width="100px"      ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >Temp
                                    <asp:TextBox ID="txtTemp1" CssClass="" runat="server"   width="100px"     ClientIDMode="Static" ></asp:TextBox>
                                
                                    
                                    </td>
                                <td class="GridViewLabItemStyle"  >Resp
                                    <asp:TextBox ID="txtResp1" CssClass="" runat="server"   width="100px"     ClientIDMode="Static" ></asp:TextBox>
                                
                                    
                                    </td>
                            </tr>
                             <tr>
                                  
                                  <td class="GridViewLabItemStyle"  >
                                  Baby Length

                                  </td>
                                <td class="GridViewLabItemStyle"  > 
                                   <asp:TextBox ID="txtLength" CssClass="" runat="server"    width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                  </td>
                                <td class="GridViewLabItemStyle"  >
                                  
                                    </td>
                                <td class="GridViewLabItemStyle"  >
                                   Weight
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                        <asp:TextBox ID="txtWeight" CssClass="" runat="server"    width="100px"    ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                <td class="GridViewLabItemStyle"  >HC
                                
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                    <asp:TextBox ID="txtHC" CssClass="" runat="server"   width="100px"     ClientIDMode="Static" ></asp:TextBox>
                                
                                    </td>
                                <td class="GridViewLabItemStyle"  >Drugs Given
                                    
                                    </td>
                                
                                <td class="GridViewLabItemStyle"  >
                                    <asp:TextBox ID="txtDrugsGiven" CssClass="" runat="server"  width="100px"      ClientIDMode="Static" ></asp:TextBox>
                                
                                    
                                    </td>
                                <td class="GridViewLabItemStyle"  >Delivery By
                                    <asp:TextBox ID="txtDeliveryBy" CssClass="" runat="server"  width="100px"      ClientIDMode="Static" ></asp:TextBox>
                                
                                    
                                    </td>
                            </tr>
                           
                             </table>
                        
                        </div>
                               
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                    </div>
                </div>
                </div>
                
                <div class="POuter_Box_Inventory" style="text-align: center">
                    <table style="width:100%;">
                     <tr  >
                                 <td class="GridViewLabItemStyle"  ><b>Last UpdatedBy</b></td>
                                 <td class="GridViewLabItemStyle"  >
                                <asp:Label ID="lblLastUpdatedBy" runat="server" Visible="true"></asp:Label>
                                     </td>
                                  <td class="GridViewLabItemStyle"  ><b>Last Updated Date</b></td>
                                 <td class="GridViewLabItemStyle"  >
                                <asp:Label ID="lblLastUpdateDate" runat="server" Visible="true"></asp:Label>
                                     </td>
                         <td  class="GridViewLabItemStyle" >
                              <asp:Button ID="Btnsave" ClientIDMode="Static" runat="server" OnClick="btnSave_Click" Text="save" CssClass="ItDoseButton" OnClientClick="return note();" />               
                <asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return note();" OnClick="btnUpdate_Click" />
               
                         </td>
                            </tr>
                             </table>
                        
                    </div>
                <div class="POuter_Box_Inventory" style="text-align: center">
                </div>

         </div>
      </div>
   </form>
</body>
</html>