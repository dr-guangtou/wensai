---
title: "Apache Kafka for Scientific Facilities - Quick Summary"
date: 2026-02-25
topic: "Data Infrastructure & Streaming"
category: "Data Engineering"
tags: ["kafka", "streaming", "data-pipeline", "real-time", "astronomy", "must", "rubin"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# Apache Kafka for Scientific Facilities - Quick Summary

---

## What is Kafka?

**Apache Kafka** is a **distributed event streaming platform** designed for high-throughput, real-time data pipelines. Think of it as a **massive, distributed message queue** that can handle millions of events per second.

**Simple Analogy:** Kafka is like a **high-speed postal system** for data:
- **Producers** drop messages into **topics** (mailboxes)
- **Consumers** pick up messages from topics
- Messages are **retained** for a configurable period
- Multiple consumers can read the same message

---

## Key Concepts

| Concept | Description | Analogy |
|---------|-------------|---------|
| **Topic** | Category/feed of messages | Mailbox / Folder |
| **Producer** | Source that publishes messages | Sender |
| **Consumer** | Receiver that reads messages | Recipient |
| **Broker** | Server that stores messages | Post office |
| **Partition** | Topic split for parallelism | Mail slot |
| **Offset** | Position in a partition | Page number |

---

## Architecture Overview

```
┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│  Telescope  │   │  Sensors    │   │  Weather    │
│  Control    │   │  & Monitors │   │  Station    │
└──────┬──────┘   └──────┬──────┘   └──────┬──────┘
       │                 │                 │
       ▼                 ▼                 ▼
┌─────────────────────────────────────────────────┐
│              KAFKA CLUSTER                       │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐          │
│  │ Topic:  │  │ Topic:  │  │ Topic:  │          │
│  │ Images  │  │ Alerts  │  │Eng. Data│          │
│  └─────────┘  └─────────┘  └─────────┘          │
│       │            │            │               │
│       ▼            ▼            ▼               │
│  [Retained for configurable period]            │
└─────────────────────────────────────────────────┘
       │            │            │
       ▼            ▼            ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   Archive   │ │   Alert     │ │ Monitoring  │
│   System    │ │   System    │ │ Dashboard   │
└─────────────┘ └─────────────┘ └─────────────┘
```

---

## Why Kafka for Science Facilities?

| Requirement | Kafka's Solution |
|-------------|------------------|
| **High throughput** | Millions of events/second |
| **Real-time** | Sub-millisecond latency |
| **Data retention** | Store data for hours to weeks |
| **Multiple consumers** | Many systems can read same data |
| **Fault tolerance** | Replicated across brokers |
| **Scalability** | Add brokers as needed |
| **Decoupling** | Producers and consumers independent |

---

## Kafka at Vera Rubin Observatory

The **Vera C. Rubin Observatory** (LSST) uses Kafka extensively for:

### 1. Engineering Data Stream
```
Sensors → Kafka → Real-time Monitoring
                  → Historical Archive
                  → Anomaly Detection
```

**Data types:**
- Telescope mount position (azimuth, elevation)
- Mirror temperatures (100+ sensors)
- Camera cooling system status
- Dome position and environmental data
- Power consumption metrics
- Network health statistics

### 2. Transient Alert System
```
Image → Pipeline → Candidate Detection → Kafka → Brokers
                                                → Follow-up Telescopes
                                                → Community Alerts
```

**Alert stream characteristics:**
- ~10 million alerts per night
- <60 second latency from observation to alert
- Packaged as Avro messages with cutouts
- Distributed to ~40 community brokers worldwide

### 3. Observatory Control System (OCS)
- Real-time telemetry from all subsystems
- Command acknowledgment streams
- Inter-process communication between control systems

---

## Potential Applications for MUST

### Operations Use Cases

| System | Kafka Application |
|--------|-------------------|
| **Telescope Control** | Real-time position feedback, tracking status |
| **Focal Plane** | Detector readout status, temperature monitoring |
| **Spectrograph** | Spectral quality metrics, throughput monitoring |
| **Dome/Enclosure** | Environmental data, humidity, temperature |
| **Data Management** | File transfer status, pipeline progress |

### Science Use Cases

| Application | Description |
|-------------|-------------|
| **Transient Alerts** | Real-time alerts for variable sources, supernovae, TDEs |
| **Survey Progress** | Live coverage maps, completion status |
| **Quality Monitoring** | Real-time data quality metrics per exposure |
| **Cosmology Pipelines** | Stream processed redshifts, galaxy properties |
| **Community Data Access** | Broker-style data distribution to collaborators |

### MUST-Specific Architecture Concept

```
┌────────────────────────────────────────────────────────────┐
│                    MUST OBSERVATORY                         │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐    │
│  │ Focal   │   │ Spectro │   │  Dome   │   │ Weather │    │
│  │ Plane   │   │ graphs  │   │ Control │   │ Station │    │
│  └────┬────┘   └────┬────┘   └────┬────┘   └────┬────┘    │
│       │             │             │             │          │
│       ▼             ▼             ▼             ▼          │
│  ┌─────────────────────────────────────────────────────┐  │
│  │              KAFKA CLUSTER (On-site)                 │  │
│  │                                                      │  │
│  │  Topics:                                             │  │
│  │  • must.raw spectra metadata                        │  │
│  │  • must.eng.focal plane temps                       │  │
│  │  • must.eng.spectrograph status                     │  │
│  │  • must.env.weather                                 │  │
│  │  • must.alerts.transients                           │  │
│  │  • must.science.redshifts                           │  │
│  └─────────────────────────────────────────────────────┘  │
│                          │                                 │
└──────────────────────────┼─────────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────────┐
│                   TSINGHUA / CLOUD                          │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐    │
│  │ Archive │   │Science  │   │ Alert   │   │ Dashboard│   │
│  │ Storage │   │Pipeline │   │ Brokers │   │  (Ops)   │   │
│  └─────────┘   └─────────┘   └─────────┘   └─────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Secondary Kafka (Cloud) for:                       │  │
│  │  • Community data distribution                      │  │
│  │  • External broker access                           │  │
│  │  • Long-term retention                              │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

## Kafka vs Alternatives

| System | Throughput | Latency | Retention | Best For |
|--------|------------|---------|-----------|----------|
| **Kafka** | Millions/s | ms | Days-weeks | Event streaming, logs |
| **RabbitMQ** | Thousands/s | ms | None (queue) | Task queues, RPC |
| **Redis Streams** | Hundreds of K/s | μs | Hours | Real-time caching |
| **FITS files** | N/A | N/A | Forever | Science data storage |
| **Database** | Thousands/s | ms | Forever | Queries, transactions |

**Key Insight:** Kafka complements FITS/databases — it handles the **real-time stream**, while files/databases handle **persistent storage**.

---

## Quick Technical Details

### Message Format

Kafka messages are typically:
- **Key:** (optional) For partitioning
- **Value:** Actual data (often Avro, JSON, or Protocol Buffers)
- **Timestamp:** When message was created
- **Headers:** Metadata

### Typical Configuration

| Parameter | Typical Value |
|-----------|---------------|
| **Replication factor** | 3 (fault tolerance) |
| **Partitions per topic** | 3-12 (depends on throughput) |
| **Retention period** | 7-30 days (adjustable) |
| **Message size** | Up to 1MB (configurable) |

### Performance Characteristics

| Metric | Typical Value |
|--------|---------------|
| **Throughput** | 1M+ messages/second per cluster |
| **Latency** | <10ms (p99) |
| **Message size** | Bytes to MB |
| **Storage** | TB to PB (depends on retention) |

---

## Getting Started

### Command Line

```bash
# Start Kafka (using Docker)
docker run -d --name kafka \
  -p 9092:9092 \
  apache/kafka:latest

# Create topic
docker exec kafka kafka-topics.sh --create \
  --topic must.alerts \
  --bootstrap-server localhost:9092 \
  --partitions 3 \
  --replication-factor 1

# Produce message
docker exec kafka kafka-console-producer.sh \
  --topic must.alerts \
  --bootstrap-server localhost:9092

# Consume messages
docker exec kafka kafka-console-consumer.sh \
  --topic must.alerts \
  --from-beginning \
  --bootstrap-server localhost:9092
```

### Python (confluent-kafka)

```bash
pip install confluent-kafka
```

```python
from confluent_kafka import Producer, Consumer

# Producer
producer = Producer({'bootstrap.servers': 'localhost:9092'})
producer.produce('must.alerts', key='alert_001', value=b'{"ra": 150.5, "dec": 2.3}')
producer.flush()

# Consumer
consumer = Consumer({
    'bootstrap.servers': 'localhost:9092',
    'group.id': 'must_processor',
    'auto.offset.reset': 'latest'
})
consumer.subscribe(['must.alerts'])

while True:
    msg = consumer.poll(1.0)
    if msg:
        print(f"Received: {msg.key()}: {msg.value()}")
```

---

## Key Takeaways for MUST

1. **Real-time telemetry:** Stream all engineering data through Kafka for monitoring, alerting, and archival

2. **Transient alerts:** Follow Rubin's model — use Kafka for low-latency alert distribution to community brokers

3. **Pipeline orchestration:** Kafka can coordinate data processing stages (raw → calibrated → science-ready)

4. **Decoupled architecture:** Each subsystem produces to Kafka independently; consumers don't need to know about producers

5. **Retention flexibility:** Keep engineering data for weeks, alerts for days, or stream to permanent storage

6. **Scalability:** Start small, scale horizontally as MUST's data rate grows

---

## Resources

### Official
- **Website:** https://kafka.apache.org/
- **Documentation:** https://kafka.apache.org/documentation/

### Astronomy Context
- **Rubin Observatory:** https://rubinobservatory.org/ (alert system documentation)
- **LSST Alert Distribution:** Uses Kafka + Avro for 10M+ alerts/night

### Python Libraries
- **confluent-kafka:** https://github.com/confluentinc/confluent-kafka-python
- **kafka-python:** https://github.com/dpkp/kafka-python

---

*Summary compiled by Yuzhe | Research Assistant*  
*Date: 2026-02-25*
